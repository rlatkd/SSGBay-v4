# 프로바이더
provider "aws" {
  region = "ap-northeast-2"
}

# iam.tf을 참조하여 사용자 생성
module "iam_users" {
  source = "./iam.tf"
}

resource "aws_iam_user" "rlatkdReact" {
  name = module.iam_users.aws_iam_user.rlatkdReact.name
}

resource "aws_iam_user" "rlatkdFlask" {
  name = module.iam_users.aws_iam_user.rlatkdFlask.name
}

resource "aws_iam_user" "rlatkdMySQL" {
  name = module.iam_users.aws_iam_user.rlatkdMySQL.name
}