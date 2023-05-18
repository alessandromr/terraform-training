resource "aws_iam_role" "github-demo" {
  depends_on = [aws_iam_openid_connect_provider.github]

  name               = "github-terraform-demo-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.github-demo-assume-policy.json
}

data "aws_iam_policy_document" "github-demo-assume-policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:alessandromr/terraform-training:*"]
    }
  }
}

resource "aws_iam_role_policy" "github-demo" {
  name = "github-terraform-demo-${terraform.workspace}"
  role = aws_iam_role.github-demo.id

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