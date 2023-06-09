# Cloud Resume Challenge - Infrastructure and Back-end

This repository contains the infrastructure and back-end components of the Cloud Resume Challenge project. The goal of the project is to create a resume website with a visitor counter, hosted on Amazon S3 and served through Amazon CloudFront. The back-end is responsible for managing the visitor counter and consists of a DynamoDB table, an AWS Lambda function, and an API Gateway. The infrastructure is provisioned using Terraform.

## Architecture

The architecture of the back-end and infrastructure is as follows:

1. **Amazon S3**: Hosts the static files for the resume website.
2. **Amazon CloudFront**: CDN for serving the resume website with HTTPS.
3. **DynamoDB**: Stores the visitor count.
4. **AWS Lambda**: A serverless function, written in Python, that retrieves and updates the visitor count from the DynamoDB table.
5. **API Gateway**: Provides an API endpoint for the front-end to interact with the Lambda function.