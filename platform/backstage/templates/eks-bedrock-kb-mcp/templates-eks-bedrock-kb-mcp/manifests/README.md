# Bedrock Knowledge Base MCP Server on EKS

This deployment sets up the Bedrock Knowledge Base MCP Server on an EKS cluster with Keycloak integration for user authentication. The MCP server enables Amazon Q Developer to query your Amazon Bedrock Knowledge Bases using natural language.

## Components

1. **Bedrock KB MCP Server**: The main server that interfaces with Amazon Bedrock Knowledge Bases
2. **Keycloak Integration**: Authentication and authorization for users accessing the MCP server
3. **Amazon Q Configuration**: Configuration for Amazon Q Developer to connect to the MCP server

## Prerequisites

1. An EKS cluster with IAM OIDC provider configured
2. A Keycloak server accessible from the EKS cluster
3. An IAM role with permissions for Amazon Bedrock Knowledge Bases
4. At least one Amazon Bedrock Knowledge Base with the tag `mcp-multirag-kb=true`

## Connecting Amazon Q Developer

To connect Amazon Q Developer to the MCP server:

1. Get the external endpoint of the MCP server:
   ```bash
   kubectl get svc -n ${{values.namespace}} bedrock-kb-mcp-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
   ```

2. Create a local configuration file:
   ```bash
   mkdir -p ~/.aws/amazonq
   ```

3. Create a file at `~/.aws/amazonq/mcp.json` with the following content:
   ```json
   {
     "version": "1.0",
     "mcps": [
       {
         "name": "bedrock-kb-mcp",
         "endpoint": "http://<LOAD_BALANCER_URL>:8080",
         "auth": {
           "type": "oauth2",
           "oauth2": {
             "clientId": "${{values.keycloakClientId}}",
             "authorizationEndpoint": "https://${{values.keycloakUrl}}/realms/${{values.keycloakRealm}}/protocol/openid-connect/auth",
             "tokenEndpoint": "https://${{values.keycloakUrl}}/realms/${{values.keycloakRealm}}/protocol/openid-connect/token"
           }
         }
       }
     ]
   }
   ```

4. Replace `<LOAD_BALANCER_URL>` with the actual endpoint from step 1.

5. Use Amazon Q Developer to query your knowledge bases:
   ```bash
   q chat "What information do we have about project X?"
   ```

## Troubleshooting

If you encounter issues:

1. Check the MCP server logs:
   ```bash
   kubectl logs -n ${{values.namespace}} -l app=bedrock-kb-mcp
   ```

2. Verify the Keycloak configuration:
   ```bash
   kubectl describe secret -n ${{values.namespace}} bedrock-kb-mcp-keycloak
   ```

3. Test connectivity to the MCP server:
   ```bash
   kubectl run -it --rm --restart=Never curl-test --image=curlimages/curl -- curl -v http://bedrock-kb-mcp-service:8080
   ```