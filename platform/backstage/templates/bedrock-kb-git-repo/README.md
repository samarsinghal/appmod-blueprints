# Bedrock Knowledge Base from Git Repository Template

This template creates an Amazon Bedrock Knowledge Base that ingests content from a Git repository. It automates the following steps:

1. Creates an S3 bucket to store the Git repository content
2. Clones the specified Git repository and uploads its contents to the S3 bucket
3. Creates a Bedrock knowledge base with the appropriate configuration
4. Configures the knowledge base to use the S3 bucket as a data source

## Prerequisites

Before using this template, ensure you have:

1. **IAM Role with Proper Permissions**:
   - Create an IAM role with the following permissions:
     - Amazon Bedrock Knowledge Bases access (`bedrock-agent:*`)
     - S3 access (`s3:*`)
     - `bedrock:InvokeModel` and `bedrock:Rerank` (for embedding and reranking)

2. **AWS Region with Bedrock Support**:
   - Ensure you're using a region where Amazon Bedrock is available

## Parameters

The template requires the following parameters:

### Git Repository Information
- **Git Repository URL**: URL of the Git repository to use as a data source
- **Branch**: Branch of the Git repository to use (default: main)

### Knowledge Base Information
- **Knowledge Base Name**: Name of the Bedrock Knowledge Base
- **AWS Region**: AWS region for the Knowledge Base
- **S3 Bucket Name**: Name of the S3 bucket to store repository content
- **IAM Role ARN**: ARN of the IAM role with permissions for Bedrock and S3
- **Namespace**: Kubernetes namespace to create resources in (default: default)

## How It Works

1. The template creates an S3 bucket using the OAM S3 bucket component
2. A Kubernetes job clones the Git repository and uploads its contents to the S3 bucket
3. Another Kubernetes job creates the Bedrock knowledge base and configures it to use the S3 bucket as a data source
4. The knowledge base is tagged with `mcp-multirag-kb: true` for integration with the MCP server

## Using the Knowledge Base

Once the knowledge base is created and the data is ingested, you can use it with:

1. The AWS Console for testing queries
2. The Bedrock Knowledge Base MCP server for integration with Amazon Q Developer
3. Custom applications using the Bedrock API

## Troubleshooting

If you encounter issues:

1. Check the Kubernetes job logs for errors
2. Verify the IAM role has the necessary permissions
3. Ensure the Git repository is accessible
4. Check the AWS Console for the status of the knowledge base and data source