resource "aws_ecr_repository" "my_tf_function" {
  name = "my-tf-function"
}

resource "aws_lambda_function" "my_tf_function" {
  architectures = ["x86_64"]
  image_uri     = "${aws_ecr_repository.my_tf_function.repository_url}:latest"
  role          = aws_iam_role.terraform-lambda.arn
  function_name = "MyTerraformFunction"
  package_type  = "Image"
  timeout       = 300
  memory_size   = 1024

  environment {
  }
}