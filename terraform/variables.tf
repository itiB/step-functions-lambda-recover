variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "StepFuncSampleTable"
}

variable "sqs_queue_name" {
  description = "SQS queue name"
  type        = string
  default     = "stepfunc-sample-queue"
}
