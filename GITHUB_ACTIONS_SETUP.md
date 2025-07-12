# GitHub Actions Setup for Azure Deployment

## Issues Found and Fixed

### 1. ✅ **Fixed Missing Azure Authentication**
- **Problem**: Workflow was failing with "No credentials found"
- **Solution**: Removed unnecessary Azure login steps since `azure/webapps-deploy@v2` handles authentication via publish profiles

### 2. ✅ **Fixed Package Lock File Dependencies**
- **Problem**: Workflow expected `package-lock.json` but referenced wrong cache paths
- **Solution**: 
  - Removed npm cache dependency (optional for this workflow)
  - Generated `package-lock.json` files by running `npm install`
  - Changed from `npm ci` to `npm install` for more flexibility

### 3. ✅ **Updated Dependencies Installation**
- **Problem**: Using `npm ci` without proper lock files
- **Solution**: Changed to `npm install` and `npm install --production` for backend

## Required Setup Steps

### Step 1: ✅ Create Azure Web Apps (COMPLETED)

**WAŻNE**: Nowe subskrypcje Azure wymagają rejestracji dostawców zasobów:
```bash
# Rejestracja wymaganych dostawców (wykonane automatycznie):
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.Storage  
az provider register --namespace Microsoft.Insights
```

**STATUS AKTUALNY:**
1. **Resource Group**: `azure-crud-rg` (West Europe) ✅ UTWORZONY
2. **App Service Plan**: `azure-crud-plan` (Free F1 tier) ✅ UTWORZONY
3. **Backend App**: `azure-crud-backend-app` (Node.js 22) ✅ UTWORZONY
4. **Frontend App**: `azure-crud-frontend-app` (Node.js 22) ✅ UTWORZONY

**Komendy wykonane pomyślnie:**
az group create --name azure-crud-rg --location "West Europe"
az appservice plan create --name azure-crud-plan --resource-group azure-crud-rg --sku F1 --is-linux
az webapp create --resource-group azure-crud-rg --plan azure-crud-plan --name azure-crud-backend-app --runtime "NODE:22-lts"
az webapp create --resource-group azure-crud-rg --plan azure-crud-plan --name azure-crud-frontend-app --runtime "NODE:22-lts"
```

### Step 2: 🎯 Get Publish Profiles (AKTUALNY KROK)

**Teraz pobieramy publish profiles dla obu aplikacji:**

#### Option A: Azure Portal (ZALECANE - z obrazkami)
1. **Otwórz Azure Portal**: https://portal.azure.com
2. **Znajdź Resource Group**: Wpisz `azure-crud-rg` w wyszukiwarce
3. **Dla Backend App** (`azure-crud-backend-app`):
   - Kliknij na aplikację
   - W lewym menu znajdź **"Get publish profile"** lub **"Pobierz profil publikowania"**
   - Kliknij i pobierz plik `.publishsettings`
   - Otwórz plik w notatniku i skopiuj **całą zawartość XML**
4. **Dla Frontend App** (`azure-crud-frontend-app`):
   - Powtórz te same kroki

#### Option B: Azure CLI (szybsze)
```bash
# Backend publish profile
az webapp deployment list-publishing-profiles --name azure-crud-backend-app --resource-group azure-crud-rg --xml

# Frontend publish profile  
az webapp deployment list-publishing-profiles --name azure-crud-frontend-app --resource-group azure-crud-rg --xml
```

**Uwaga**: Skopiuj **CAŁĄ zawartość XML** z każdego profilu!

### Step 3: 🔐 Add GitHub Secrets (NASTĘPNY KROK)

**Po pobraniu publish profiles, dodaj je jako secrets w GitHub:**

#### Krok po kroku:
1. **Otwórz GitHub repo**: https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai
2. **Przejdź do Settings**: Kliknij zakładkę "Settings" (na górze strony repo)
3. **Znajdź Secrets**: W lewym menu kliknij **"Secrets and variables"** → **"Actions"**
4. **Dodaj pierwszy secret**:
   - Kliknij **"New repository secret"**
   - Name: `AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND`
   - Value: **Wklej CAŁĄ zawartość XML z backend publish profile**
   - Kliknij "Add secret"
5. **Dodaj drugi secret**:
   - Kliknij **"New repository secret"** ponownie
   - Name: `AZURE_WEBAPP_PUBLISH_PROFILE_FRONTEND` 
   - Value: **Wklej CAŁĄ zawartość XML z frontend publish profile**
   - Kliknij "Add secret"

#### ⚠️ WAŻNE:
- Musisz skopiować **CAŁĄ zawartość XML** (od `<?xml` do końca)
- Nie dodawaj żadnych dodatkowych spacji ani znaków
- Upewnij się, że nazwy secrets są dokładnie takie jak podane wyżej

#### 📋 Nazwy secrets (skopiuj dokładnie):
```
AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND
AZURE_WEBAPP_PUBLISH_PROFILE_FRONTEND
```

### Step 4: Test the Workflow
After adding the secrets, trigger the workflow by:
1. Making a commit to the `main` branch, or
2. Manually running it from the Actions tab

## Updated Workflow Features

The updated `.github/workflows/azure-deploy.yml` includes:
- ✅ Proper Node.js 18.x setup
- ✅ Production dependency installation
- ✅ Automatic build process for React frontend
- ✅ Sequential deployment (backend first, then frontend)
- ✅ Simplified authentication using publish profiles

## Common Issues and Solutions

### Issue: "App name not found"
**Solution**: Ensure the app names in the workflow match your Azure App Service names:
- `AZURE_WEBAPP_NAME_BACKEND: azure-crud-backend-app`
- `AZURE_WEBAPP_NAME_FRONTEND: azure-crud-frontend-app`

### Issue: "Authentication failed"
**Solution**: 
1. Verify publish profiles are correctly copied (complete XML)
2. Ensure no extra spaces or characters in the secrets
3. Refresh publish profiles if they're old

### Issue: "Build failed"
**Solution**: 
1. Check if all dependencies are listed in `package.json`
2. Ensure React build completes successfully locally
3. Check for Node.js version compatibility

## Environment Variables (Optional)
For production deployments, you may want to add environment variables to your Azure App Services:

```bash
# Backend environment variables
az webapp config appsettings set --resource-group <rg> --name azure-crud-backend-app --settings NODE_ENV=production PORT=80

# Frontend environment variables (if needed)
az webapp config appsettings set --resource-group <rg> --name azure-crud-frontend-app --settings NODE_ENV=production
```

## Monitoring Deployment
- Check deployment status in GitHub Actions tab
- Monitor application logs in Azure Portal
- Use Azure Application Insights for detailed monitoring

---

## 🎯 AKTUALNY STATUS

### ✅ ZAKOŃCZONE:
1. Fixed GitHub Actions workflow errors
2. Resource Group utworzony: `azure-crud-rg`
3. App Service Plan utworzony: `azure-crud-plan`
4. Backend App utworzony: `azure-crud-backend-app`
5. Frontend App utworzony: `azure-crud-frontend-app`
6. ✅ **GitHub Secrets dodane pomyślnie**
7. ✅ **Deployment wykonany pomyślnie**

## 🎉 APLIKACJA JEST LIVE!

### 🌐 Twoje URLs:
- **Frontend (React App)**: https://azure-crud-frontend-app.azurewebsites.net
- **Backend (API)**: https://azure-crud-backend-app.azurewebsites.net

### 🚀 Jak otworzyć aplikację:
1. **Kliknij na Frontend URL** powyżej lub wklej w przeglądarce
2. **Lub użyj bezpośrednich linków**:
   - Frontend: https://azure-crud-frontend-app.azurewebsites.net
   - Backend API: https://azure-crud-backend-app.azurewebsites.net
3. **Lub przez Azure Portal**:
   - Idź na https://portal.azure.com
   - Znajdź `azure-crud-rg` → `azure-crud-frontend-app`
   - Kliknij "Browse" lub skopiuj URL

### 📱 Testowanie aplikacji:
- **Frontend** powinien pokazać Twoją React aplikację
- **Backend** powinien odpowiadać na `/api` endpointy
- Sprawdź czy wszystkie funkcje CRUD działają poprawnie

### 🔗 Przydatne linki:
- **Azure Portal**: https://portal.azure.com (znajdź `azure-crud-rg`)
- **GitHub Settings**: https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai/settings/secrets/actions
- **GitHub Actions**: https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai/actions

---

## Next Steps
1. ✅ Fixed workflow file
2. ⏳ Create Azure App Services  
3. ⏳ Add GitHub secrets
4. ⏳ Test deployment
5. ⏳ Configure custom domains (optional)
6. ⏳ Set up monitoring and alerts
