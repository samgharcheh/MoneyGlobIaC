# Money Globe project

## Infrastructure as Code

The MoneyGlobIaC project is a GitHub repository that provides infrastructure as code (IaC) solutions using Bicep and GitHub Actions to deploy to Azure. The project aims to simplify the deployment process and automate the infrastructure setup.

## Main Function Points

Utilizes Bicep, a domain-specific language (DSL) for Azure Resource Manager, to define the infrastructure.
Uses GitHub Actions to automate the process of deploying infrastructure to Azure.
Provides an efficient and reproducible way to deploy the infrastructure for the Money Globe project.

## Technology Stack

- Bicep
- GitHub Actions
- Azure

## Run command

```powershell
az group create -l westus -n <ResourceGroupName>

az deployment group create \
    --resource-group <ResourceGroupName> \
    --name <deployName> \
    --template-file ./main.bicep \
    --parameters parameters.bicepparam
```

## License

This project is licensed under the New Planet IT License.
