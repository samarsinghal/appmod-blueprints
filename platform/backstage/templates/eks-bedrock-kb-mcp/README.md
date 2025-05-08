# EKS Bedrock Knowledge Base MCP Server Template

This Backstage template deploys the Bedrock Knowledge Base MCP Server on an EKS cluster with Keycloak integration for user authentication. The MCP server enables Amazon Q Developer to query your Amazon Bedrock Knowledge Bases using natural language.

## Features

- Deploys the Bedrock KB MCP server on an EKS cluster
- Integrates with Keycloak for user authentication
- Configures Amazon Q Developer to connect to the MCP server
- Supports filtering and reranking of knowledge base results

## Prerequisites

1. **EKS Cluster**: You must have an existing EKS cluster
2. **Keycloak Server**: You must have a Keycloak server accessible from the EKS cluster
3. **IAM Role**: You must have an IAM role with permissions for Amazon Bedrock Knowledge Bases
4. **Knowledge Base**: You must have at least one Amazon Bedrock Knowledge Base with the tag `mcp-multirag-kb=true`

## IAM Permissions

The IAM role used by the MCP server needs the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:ListKnowledgeBases",
        "bedrock:GetKnowledgeBase",
        "bedrock:ListDataSources",
        "bedrock:GetDataSource",
        "bedrock:Retrieve",
        "bedrock:Rerank",
        "bedrock:InvokeModel"
      ],
      "Resource": "*"
    }
  ]
}
```

## Usage

1. Select the "EKS Bedrock Knowledge Base MCP Server" template in Backstage
2. Fill in the required parameters:
   - EKS Cluster Name
   - AWS Region
   - IAM Role ARN
   - Keycloak URL, Realm, and Client ID
3. Click "Create" to deploy the MCP server
4. Follow the instructions in the generated README to connect Amazon Q Developer to the MCP server

## Architecture

The template deploys the following components:

1. **Bedrock KB MCP Server**: The main server that interfaces with Amazon Bedrock Knowledge Bases
2. **Keycloak Integration**: Authentication and authorization for users accessing the MCP server
3. **Amazon Q Configuration**: Configuration for Amazon Q Developer to connect to the MCP server

## Connecting Amazon Q Developer

After deployment, you can connect Amazon Q Developer to the MCP server by:

1. Getting the external endpoint of the MCP server
2. Creating a local configuration file at `~/.aws/amazonq/mcp.json`
3. Using Amazon Q Developer to query your knowledge bases: `q chat "What information do we have about project X?"`