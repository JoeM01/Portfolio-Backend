output "api_id" {
  value = aws_api_gateway_rest_api.PortfolioAPI.id
}

output "api_resource_id" {
  value = aws_api_gateway_resource.PortfolioAPIResource.id
}