terraform {
  backend "s3" {
    key     = "webperf_codebuild.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 2.7"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "webperf" {
  byte_length = 8
}
