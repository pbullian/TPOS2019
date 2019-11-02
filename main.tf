# Specify the provider and access details
provider "aws" {
  #shared_credentials_file="/root/.aws/credentials"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"

  region = "${var.aws_region}"
}

