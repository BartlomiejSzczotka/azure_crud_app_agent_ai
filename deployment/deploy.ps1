# Azure CRUD App Deployment Script
# This script deploys the Azure CRUD application to Azure App Service

param(
    [Parameter(Mandatory=$false)]
    [string]$AppName = "azure-crud-app-$(Get-Random -Minimum 1000 -Maximum 9999)",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = "azure-crud-rg",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "East US",
    
    [Parameter(Mandatory=$false)]
    [string]$Sku = "F1"
)

Write-Host "🚀 Starting Azure CRUD App Deployment..." -ForegroundColor Green
Write-Host "App Name: $AppName" -ForegroundColor Yellow
Write-Host "Resource Group: $ResourceGroup" -ForegroundColor Yellow
Write-Host "Location: $Location" -ForegroundColor Yellow

# Check if Azure CLI is installed
try {
    az --version | Out-Null
    Write-Host "✅ Azure CLI is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Azure CLI is not installed. Please install it from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor Red
    exit 1
}

# Check if user is logged in
try {
    $account = az account show --query "name" -o tsv 2>$null
    if ($account) {
        Write-Host "✅ Logged in to Azure account: $account" -ForegroundColor Green
    } else {
        throw "Not logged in"
    }
} catch {
    Write-Host "❌ Not logged in to Azure. Please run 'az login' first." -ForegroundColor Red
    exit 1
}

# Create resource group
Write-Host "📦 Creating resource group..." -ForegroundColor Blue
az group create --name $ResourceGroup --location $Location --output table

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create resource group" -ForegroundColor Red
    exit 1
}

# Deploy ARM template
Write-Host "🏗️ Deploying Azure resources..." -ForegroundColor Blue
$deploymentResult = az deployment group create `
    --resource-group $ResourceGroup `
    --template-file "azure-template.json" `
    --parameters appName=$AppName sku=$Sku `
    --query "properties.outputs" `
    --output json

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to deploy Azure resources" -ForegroundColor Red
    exit 1
}

$outputs = $deploymentResult | ConvertFrom-Json
$backendUrl = $outputs.backendUrl.value
$frontendUrl = $outputs.frontendUrl.value

Write-Host "✅ Azure resources deployed successfully!" -ForegroundColor Green
Write-Host "Backend URL: $backendUrl" -ForegroundColor Yellow
Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Yellow

# Prepare backend for deployment
Write-Host "📝 Preparing backend deployment..." -ForegroundColor Blue
Push-Location backend

# Create deployment package
if (Test-Path "deploy.zip") {
    Remove-Item "deploy.zip"
}

# For Windows, we'll use PowerShell's Compress-Archive
$backendFiles = @(
    "src",
    "package.json",
    "package-lock.json"
)

$filesToCompress = @()
foreach ($file in $backendFiles) {
    if (Test-Path $file) {
        $filesToCompress += $file
    }
}

Compress-Archive -Path $filesToCompress -DestinationPath "deploy.zip" -Force

# Deploy backend
Write-Host "🚀 Deploying backend..." -ForegroundColor Blue
az webapp deployment source config-zip `
    --resource-group $ResourceGroup `
    --name "$AppName-backend" `
    --src "deploy.zip"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to deploy backend" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Clean up
Remove-Item "deploy.zip"
Pop-Location

# Prepare frontend for deployment
Write-Host "📝 Preparing frontend deployment..." -ForegroundColor Blue
Push-Location frontend

# Install dependencies and build
Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Blue
npm ci

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install frontend dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Set the API URL for production build
$env:REACT_APP_API_URL = $backendUrl

Write-Host "🏗️ Building frontend..." -ForegroundColor Blue
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build frontend" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Create deployment package
if (Test-Path "deploy.zip") {
    Remove-Item "deploy.zip"
}

Compress-Archive -Path "build\*" -DestinationPath "deploy.zip" -Force

# Deploy frontend
Write-Host "🚀 Deploying frontend..." -ForegroundColor Blue
az webapp deployment source config-zip `
    --resource-group $ResourceGroup `
    --name "$AppName-frontend" `
    --src "deploy.zip"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to deploy frontend" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Clean up
Remove-Item "deploy.zip"
Pop-Location

# Add serve package to frontend for production
Write-Host "📦 Installing serve package for frontend..." -ForegroundColor Blue
az webapp config appsettings set `
    --resource-group $ResourceGroup `
    --name "$AppName-frontend" `
    --settings NPM_CONFIG_PRODUCTION=false

# Install serve package
az webapp ssh -g $ResourceGroup -n "$AppName-frontend" --command "npm install -g serve"

Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Your application is now deployed:" -ForegroundColor Green
Write-Host "Frontend: $frontendUrl" -ForegroundColor Cyan
Write-Host "Backend:  $backendUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "It may take a few minutes for the applications to start up." -ForegroundColor Yellow
Write-Host "You can monitor the deployment in the Azure Portal: https://portal.azure.com" -ForegroundColor Yellow
