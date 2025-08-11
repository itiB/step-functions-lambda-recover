resource "aws_lambda_function" "main_handler" {
  function_name    = "stepfunc-main-handler"
  filename         = "../lambda/main_handler.zip"
  source_code_hash = filebase64sha256("../lambda/main_handler.zip")
  handler          = "main_handler.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}

resource "aws_lambda_function" "failure_handler" {
  function_name    = "stepfunc-failure-handler"
  filename         = "../lambda/failure_handler.zip"
  source_code_hash = filebase64sha256("../lambda/failure_handler.zip")
  handler          = "failure_handler.lambda_handler"
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}
