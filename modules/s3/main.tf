resource "aws_s3_bucket" "create_bucket" {
  bucket = "${var.name}"
  acl    = "private"
  
  tags   = {
    Name        = "Bucket for EMR Bootstrap actions/Steps"
    Environment = "Scripts"
  }
}

resource "aws_s3_bucket_object" "bootstrap_action_file" {
  bucket     = "${var.name}"
  key        = "scripts/bootstrap_actions.sh"
  source     = "scripts/bootstrap_actions.sh"
  depends_on = [aws_s3_bucket.create_bucket]
}

resource "aws_s3_bucket_object" "pyspark_quick_setup_file" {
  bucket     = "${var.name}"
  key        = "scripts/pyspark_quick_setup.sh"
  source     = "scripts/pyspark_quick_setup.sh"
  depends_on = [aws_s3_bucket.create_bucket]
}

resource "aws_s3_bucket_object" "jupyter_notebook_config_file" {
  for_each   = fileset("scripts/jupyter/config/", "*")
  bucket     = "${var.name}"
  key        = "scripts/jupyter/config/${each.value}"
  source     = "scripts/jupyter/config/${each.value}"
  depends_on = [aws_s3_bucket.create_bucket]
}

resource "aws_s3_bucket_object" "jupyter_notebook_dataprocessing_file" {
  for_each   = fileset("scripts/jupyter/notebook/", "*")
  bucket     = "${var.name}"
  key        = "scripts/jupyter/notebook/${each.value}"
  source     = "scripts/jupyter/notebook/${each.value}"
  depends_on = [aws_s3_bucket.create_bucket]
}