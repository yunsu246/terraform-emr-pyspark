resource "aws_emr_cluster" "emr-spark-cluster" {
  name                              = "${var.name}"
  release_label                     = "${var.release_label}"
  applications                      = "${var.applications}"
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "${var.subnet_id}"
    key_name                          = "${var.key_name}"
    emr_managed_master_security_group = "${var.emr_master_security_group}"
    emr_managed_slave_security_group  = "${var.emr_slave_security_group}"
    instance_profile                  = "${var.emr_ec2_instance_profile}"
  }

  ebs_root_volume_size = "12"

  master_instance_group {
    name           = "EMR master"
    instance_type  = "${var.master_instance_type}"
    instance_count = "1"

    ebs_config {
      size                 = "${var.master_ebs_size}"
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }

  core_instance_group {
    name           = "EMR slave"
    instance_type  = "${var.core_instance_type}"
    instance_count = "${var.core_instance_count}"

    ebs_config {
      size                 = "${var.core_ebs_size}"
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }

  tags = {
    Name = "${var.name} - Spark cluster"
  }

  service_role     = "${var.emr_service_role}"
  autoscaling_role = "${var.emr_autoscaling_role}"

  bootstrap_action {
    name = "Bootstrap setup."
    path = "s3://${var.name}/scripts/bootstrap_actions.sh"
  }

  step {
    name              = "Copy setup script file from s3."
    action_on_failure = "CONTINUE"

    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["aws", "s3", "cp", "s3://spark-app/scripts/pyspark_quick_setup.sh", "/home/hadoop/"]
    }
  }

  step {
    name              = "Copy jupyter notebook scripts from s3."
    action_on_failure = "CONTINUE"

    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["aws", "s3", "cp", "s3://spark-app/scripts/jupyter/notebook/", "/home/hadoop/jupyter/notebook/", "--recursive"]
    }
  }

  step {
    name              = "Copy jupyter notebook config file from s3"
    action_on_failure = "CONTINUE"

    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["aws", "s3", "cp", "s3://spark-app/scripts/jupyter/config/", "/home/hadoop/.jupyter/", "--recursive"]
    }
  }

  step {
    name              = "Setup pyspark with conda."
    action_on_failure = "CONTINUE"

    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["sudo", "bash", "/home/hadoop/pyspark_quick_setup.sh"]
    }
  }

  configurations_json = <<EOF
    [
    {
      "Classification": "spark-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
              "PYSPARK_PYTHON": "/home/hadoop/conda/bin/python",
              "PYSPARK_DRIVER_PYTHON": "/home/hadoop/conda/bin/python"
            }
        }
      ]
    }
  ]
  EOF
}
