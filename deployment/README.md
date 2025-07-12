# Azure Deployment Scripts

This directory contains scripts to help deploy the Azure CRUD application.

## Prerequisites

1. Azure CLI installed and configured
2. Azure subscription with appropriate permissions
3. Node.js 18.x installed locally

## Quick Deployment

Run the deployment script:

```powershell
.\deploy.ps1
```

This will:
1. Create a resource group
2. Deploy the ARM template
3. Set up App Services for both frontend and backend
4. Configure environment variables

## Manual Deployment Steps

If you prefer to deploy manually:

### 1. Create Resource Group
```bash
az group create --name azure-crud-rg --location "East US"
```

### 2. Deploy ARM Template
```bash
az deployment group create \
  --resource-group azure-crud-rg \
  --template-file azure-template.json \
  --parameters appName=your-unique-app-name
```

### 3. Deploy Backend
```bash
cd backend
zip -r ../backend.zip .
az webapp deployment source config-zip \
  --resource-group azure-crud-rg \
  --name your-app-name-backend \
  --src ../backend.zip
```

### 4. Deploy Frontend
```bash
cd frontend
npm run build
zip -r ../frontend.zip build/
az webapp deployment source config-zip \
  --resource-group azure-crud-rg \
  --name your-app-name-frontend \
  --src ../frontend.zip
```

## Environment Variables

The deployment automatically sets up the following environment variables:

### Backend
- `NODE_ENV`: production
- `PORT`: 8080

### Frontend
- `NODE_ENV`: production
- `REACT_APP_API_URL`: Backend App Service URL

## Monitoring

After deployment, you can monitor your application:

1. Azure Portal: https://portal.azure.com
2. Application Insights (if enabled)
3. App Service logs

## Troubleshooting

Common issues and solutions:

1. **Deployment fails**: Check Azure CLI authentication
2. **App won't start**: Check application logs in Azure Portal
3. **Frontend can't connect to backend**: Verify CORS settings and API URL
