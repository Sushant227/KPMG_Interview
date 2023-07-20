terraform {
  backend "local" {
    path = "/root/terraform/state/terraform.tfstate"
  }
  required_version = "~> 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  #shared_config_files      = ["/Users/tf_user/.aws/conf"]
  #shared_credentials_files = ["/Users/tf_user/.aws/creds"]
  profile                  = var.profilename
}

#if you are using IAM user instaed of SSO then please provide below arguments in the provider block
#  access_key = "my-access-key"
#  secret_key = "my-secret-key"

provider "aws" {
  alias = "sandbox"
  region = "us-east-1"
  #shared_config_files      = ["~.aws/config"]
  #shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.sandbox_profilename
}

module "network" {
  source = "modules/Network"
  #please specify which provider you need to use by default aws will be used but if you want to use aliased provider then use below argument 
  #provider = aws.sandbox
}

module "asg" {
  source = "modules/ASG"

  depends_on = [module.network]
}

module "database" {
  source = "modules/Database"

  depends_on = [module.asg]
}




