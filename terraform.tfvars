# EMR general configurations
name = "spark-app"
region = "ap-northeast-2"
subnet_id = "<subet_id>"
vpc_id = "<vpc_id>"
key_name = "<key_name>"
ingress_cidr_blocks = "0.0.0.0/0"
release_label = "emr-5.33.0"
applications = ["Hadoop", "Spark"]

# Master node configurations
master_instance_type = "m3.xlarge"
master_ebs_size = "50"

# Slave nodes configurations
core_instance_type = "m3.xlarge"
core_instance_count = 1
core_ebs_size = "50"
