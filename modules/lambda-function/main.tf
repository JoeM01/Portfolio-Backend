data "archive_file" "lambda_src" {
  type = "zip"
  source_file = "modules/lambda-function/src/updateVisitorCounter.py"
  output_path = "function.zip"
}

resource "aws_lambda_function" "lambda" {

    filename = "function.zip"
    function_name = "PortfolioVisitorCounter"
    role = aws_iam_role.portfolio_lambda_counter_role.arn
    handler = "updateVisitorCounter.lambda_handler"

    source_code_hash = filebase64sha256(data.archive_file.lambda_src.output_path)

    runtime = "python3.9"
}

data "aws_iam_policy_document" "lambda_iam_policy" {
    statement {
      effect = "Allow"

      actions = [ "dynamodb:UpdateItem",
      "dynamodb:GetItem" ]

      resources = [var.db_arn]
    }
}

data "aws_iam_policy_document" "assume_role" {
    statement {
      effect = "Allow"

      principals {
        type = "Service"
        identifiers = [ "lambda.amazonaws.com" ]
      }

      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "portfolio_lambda_counter_role" {
    name = "PortfolioCounterLambdaRole"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json

    inline_policy {
      name = "PortfolioPolicy"
      policy = data.aws_iam_policy_document.lambda_iam_policy.json
    }
  
}