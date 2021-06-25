terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-persistence"
    key     = "terraform-emr-pyspark.tfstate"
    region  = "ap-northeast-2"
  }
}

provider "aws" {
  region     = "${var.region}"
}
