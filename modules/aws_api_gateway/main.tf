resource "aws_api_gateway_rest_api" "PortfolioAPI" {
  name = "PortfolioAPI"
  description = "API Gateway for Portfolio website"
}

resource "aws_api_gateway_resource" "PortfolioAPIResource" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  parent_id = aws_api_gateway_rest_api.PortfolioAPI.root_resource_id
  path_part = "counter"
}

resource "aws_api_gateway_method" "PortfolioAPIMethod" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  resource_id = aws_api_gateway_resource.PortfolioAPIResource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "PortfolioAPIIntegration" {
    rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
    resource_id = aws_api_gateway_resource.PortfolioAPIResource.id
    http_method = aws_api_gateway_method.PortfolioAPIMethod.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = var.lambda_arn
}

resource "aws_api_gateway_deployment" "PortfolioAPIDeployment" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  stage_name = "prod"

  triggers = {
    redeployment = sha1(join("", [jsonencode([
        aws_api_gateway_resource.PortfolioAPIResource,
        aws_api_gateway_method.PortfolioAPIMethod,
        aws_api_gateway_integration.PortfolioAPIIntegration
    ]),
    filesha1("main.tf")]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.PortfolioAPI.execution_arn}/*/*"
  
}

resource "aws_api_gateway_method" "PortfolioAPIOptionsMethod" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  resource_id = aws_api_gateway_resource.PortfolioAPIResource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "PortfolioAPIOptionsMethodResponse" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  resource_id = aws_api_gateway_resource.PortfolioAPIResource.id
  http_method = aws_api_gateway_method.PortfolioAPIOptionsMethod.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "PortfolioAPIOptionsMethodIntegration" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  resource_id = aws_api_gateway_resource.PortfolioAPIResource.id
  http_method = aws_api_gateway_method.PortfolioAPIOptionsMethod.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "PortfolioAPIOptionsMethodIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.PortfolioAPI.id
  resource_id = aws_api_gateway_resource.PortfolioAPIResource.id
  http_method = aws_api_gateway_method.PortfolioAPIOptionsMethod.http_method
  status_code = aws_api_gateway_method_response.PortfolioAPIOptionsMethodResponse.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

