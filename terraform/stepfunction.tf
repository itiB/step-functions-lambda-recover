resource "aws_sfn_state_machine" "sample" {
  name     = "stepfunc-sample-machine"
  role_arn = aws_iam_role.sfn_exec.arn
  definition = templatefile("${path.module}/stepfunction.json", {
    MainLambdaArn    = aws_lambda_function.main_handler.arn
    FailureLambdaArn = aws_lambda_function.failure_handler.arn
  })
}

resource "aws_iam_role" "sfn_exec" {
  name = "stepfunc_sfn_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "sfn_policy" {
  name = "stepfunc_sfn_policy"
  role = aws_iam_role.sfn_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.main_handler.arn,
          aws_lambda_function.failure_handler.arn
        ]
      }
    ]
  })
}
