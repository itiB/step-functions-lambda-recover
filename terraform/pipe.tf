resource "aws_pipes_pipe" "sqs_to_stepfunc" {
  name     = "stepfunc-sample-pipe"
  role_arn = aws_iam_role.pipe_exec.arn

  source = aws_sqs_queue.stepfunc_sample.arn
  source_parameters {
    sqs_queue_parameters {
      batch_size = 1
    }
  }

  target = aws_sfn_state_machine.sample.arn
  target_parameters {
    step_function_state_machine_parameters {
      invocation_type = "FIRE_AND_FORGET"
    }
  }
}

resource "aws_iam_role" "pipe_exec" {
  name = "stepfunc_pipe_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "pipes.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "pipe_policy" {
  name = "stepfunc_pipe_policy"
  role = aws_iam_role.pipe_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.stepfunc_sample.arn
      },
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = aws_sfn_state_machine.sample.arn
      }
    ]
  })
}
