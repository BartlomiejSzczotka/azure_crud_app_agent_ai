# Azure Deployment Guide

This guide will help you deploy your Azure CRUD application to Azure App Service.

## Option 1: Quick Deployment (Recommended)

### Prerequisites
1. Azure CLI installed: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
2. Azure subscription with appropriate permissions
3. PowerShell (Windows) or Bash (Linux/Mac)

### Steps
1. Open PowerShell as Administrator
2. Navigate to your project directory:
   ```powershell
   cd "c:\Users\szczo\project\azure_crud_app_agent_ai"
   ```

3. Log in to Azure:
   ```powershell
   az login
   ```

4. Run the deployment script:
   ```powershell
   .\deployment\deploy.ps1
   ```

   Optional parameters:
   ```powershell
   .\deployment\deploy.ps1 -AppName "my-custom-app" -ResourceGroup "my-rg" -Location "West US 2"
   ```

5. Wait for deployment to complete (5-10 minutes)

## Option 2: Azure Portal Deployment

### Step 1: Create Resource Group
1. Go to https://portal.azure.com
2. Click "Resource groups" → "Create"
3. Enter name: `azure-crud-rg`
4. Select region: `East US`
5. Click "Review + create" → "Create"

### Step 2: Deploy ARM Template
1. In the resource group, click "Create"
2. Search for "Template deployment"
3. Click "Build your own template in the editor"
4. Copy and paste the content from `azure-template.json`
5. Click "Save"
6. Fill in parameters:
   - App Name: `azure-crud-app-[random-number]`
   - Location: `East US`
   - SKU: `F1` (Free tier)
7. Click "Review + create" → "Create"

### Step 3: Deploy Applications

#### Backend Deployment
1. Navigate to the backend App Service in Azure Portal
2. Go to "Deployment Center"
3. Choose "Local Git" or "GitHub" as source
4. If using Local Git:
   ```bash
   cd backend
   git init
   git add .
   git commit -m "Initial commit"
   git remote add azure [your-git-url-from-portal]
   git push azure main
   ```

#### Frontend Deployment
1. Build the frontend locally:
   ```powershell
   cd frontend
   npm install
   npm run build
   ```
2. Navigate to the frontend App Service in Azure Portal
3. Go to "App Service Editor" or use deployment slots
4. Upload the contents of the `build` folder

## Option 3: GitHub Actions (CI/CD)

1. Fork this repository to your GitHub account
2. In Azure Portal, get the publish profiles for both apps:
   - Go to each App Service → "Get publish profile"
   - Download the .publishsettings files

3. In your GitHub repository, go to Settings → Secrets and variables → Actions
4. Add these secrets:
   - `AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND`: Content of backend publish profile
   - `AZURE_WEBAPP_PUBLISH_PROFILE_FRONTEND`: Content of frontend publish profile

5. Update the workflow file `.github/workflows/azure-deploy.yml`:
   - Change `AZURE_WEBAPP_NAME_BACKEND` to your backend app name
   - Change `AZURE_WEBAPP_NAME_FRONTEND` to your frontend app name

6. Push to main branch to trigger deployment

## Post-Deployment Configuration

### Environment Variables
The deployment automatically sets up these environment variables:

**Backend:**
- `NODE_ENV`: production
- `PORT`: 8080

**Frontend:**
- `NODE_ENV`: production
- `REACT_APP_API_URL`: [Backend App Service URL]

### Custom Domain (Optional)
1. In Azure Portal, go to your frontend App Service
2. Click "Custom domains"
3. Add your custom domain
4. Configure DNS records as instructed

### SSL Certificate (Optional)
1. In Azure Portal, go to your App Service
2. Click "TLS/SSL settings"
3. Add a managed certificate or upload your own

## Monitoring and Troubleshooting

### Application Insights (Recommended)
1. Create an Application Insights resource
2. Add the instrumentation key to your app settings
3. Monitor performance, errors, and usage

### Logs
- **Azure Portal**: App Service → Log stream
- **Kudu**: https://[your-app-name].scm.azurewebsites.net
- **CLI**: `az webapp log tail --name [app-name] --resource-group [rg-name]`

### Common Issues

1. **App won't start**:
   - Check logs in Azure Portal
   - Verify Node.js version (should be 18.x)
   - Ensure package.json has correct start script

2. **Frontend can't connect to backend**:
   - Verify CORS settings in backend
   - Check REACT_APP_API_URL environment variable
   - Ensure backend is running

3. **Deployment fails**:
   - Check Azure CLI authentication: `az account show`
   - Verify resource group exists
   - Check Azure subscription permissions

## Scaling and Production Considerations

### App Service Plan
- **F1 (Free)**: Good for development/testing
- **B1 (Basic)**: Recommended for production
- **S1+ (Standard)**: For high-traffic applications

### Database
The current app uses in-memory storage. For production:
1. Create Azure SQL Database
2. Update connection strings
3. Implement proper data persistence

### Security
1. Enable HTTPS only
2. Configure authentication if needed
3. Set up proper CORS policies
4. Use Azure Key Vault for secrets

## Cost Optimization

1. Use Free tier (F1) for development
2. Scale up/down based on usage
3. Monitor costs in Azure Cost Management
4. Consider reserved instances for predictable workloads

## Support

For issues with this deployment:
1. Check Azure documentation
2. Review application logs
3. Contact Azure support if needed
