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

## Create Azure Resource Group

```powershell
az group create -g NameOfGroup -l westus3
```

## Create resource group deployment and deploy

```powershell
az deployment group create -g MyFirstDemo -f main.bicep
```

## subscription deployment

```powershell
az deployment sub create --name <deployment-name> --location <location> --template-file <path-to-bicep>
```

## management group deployments

```powershell
az deployment mg create --name <deployment-name> --management-group-id <mgid> --template-file <path-to-bicep>
```

## az build a json file

```powershell
az bicep build -f filename.bicep
```

## upgrade

```powershell
az bicep upgrade
```

## version

```powershell
az bicep version
```

## clean up - delete resource group

```powershell
az group delete --name exampleGroup
```

## azure Service principal setup

```powershell
az ad sp create-for-rbac --name "YourSPName" --role contributor --scopes /subscriptions/yourSubscriptionId
```

### or we can set it for the resource groups

``` powershell
az ad sp create-for-rbac --name {app-name} --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/exampleRG --json-auth
```

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
