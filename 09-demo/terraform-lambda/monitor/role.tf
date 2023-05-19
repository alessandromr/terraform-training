resource "aws_iam_role" "terraform-lambda" {
  name               = "github-terraform-lambda-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.terraform-lambda-assume-policy.json
}

data "aws_iam_policy_document" "terraform-lambda-assume-policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role_policy" "terraform-lambda" {
  name = "github-terraform-lambda-${terraform.workspace}"
  role = aws_iam_role.terraform-lambda.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}