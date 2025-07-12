# Azure Setup Script - Automatyczne tworzenie zasobów
# Po rejestracji dostawców uruchom ten skrypt

Write-Host "🚀 Rozpoczynam tworzenie zasobów Azure..." -ForegroundColor Green

# Sprawdzenie statusu rejestracji dostawców
Write-Host "📋 Sprawdzam status dostawców..." -ForegroundColor Yellow
az provider show --namespace Microsoft.Web --query "registrationState" --output tsv

# Tworzenie App Service Plan
Write-Host "📦 Tworzę App Service Plan..." -ForegroundColor Yellow
az appservice plan create --name azure-crud-plan --resource-group azure-crud-rg --sku F1 --is-linux

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ App Service Plan utworzony pomyślnie" -ForegroundColor Green
    
    # Tworzenie Backend App
    Write-Host "🔧 Tworzę Backend App..." -ForegroundColor Yellow
    az webapp create --resource-group azure-crud-rg --plan azure-crud-plan --name azure-crud-backend-app --runtime "NODE:22-lts"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Backend App utworzony pomyślnie" -ForegroundColor Green
    } else {
        Write-Host "❌ Błąd podczas tworzenia Backend App" -ForegroundColor Red
    }
    
    # Tworzenie Frontend App
    Write-Host "🎨 Tworzę Frontend App..." -ForegroundColor Yellow
    az webapp create --resource-group azure-crud-rg --plan azure-crud-plan --name azure-crud-frontend-app --runtime "NODE:22-lts"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Frontend App utworzony pomyślnie" -ForegroundColor Green
    } else {
        Write-Host "❌ Błąd podczas tworzenia Frontend App" -ForegroundColor Red
    }
    
    # Podsumowanie
    Write-Host "`n🎉 Tworzenie zasobów zakończone!" -ForegroundColor Green
    Write-Host "📋 Lista utworzonych aplikacji:" -ForegroundColor Yellow
    az webapp list --resource-group azure-crud-rg --output table
    
    Write-Host "`n📝 Następne kroki:" -ForegroundColor Cyan
    Write-Host "1. Przejdź do Azure Portal: https://portal.azure.com" -ForegroundColor White
    Write-Host "2. Znajdź swoje aplikacje:" -ForegroundColor White
    Write-Host "   - azure-crud-backend-app" -ForegroundColor White
    Write-Host "   - azure-crud-frontend-app" -ForegroundColor White
    Write-Host "3. Pobierz publish profiles dla każdej aplikacji" -ForegroundColor White
    Write-Host "4. Dodaj je jako secrets w GitHub" -ForegroundColor White
    
} else {
    Write-Host "❌ Błąd podczas tworzenia App Service Plan" -ForegroundColor Red
    Write-Host "💡 Sprawdź czy dostawcy są zarejestrowane:" -ForegroundColor Yellow
    az provider list --query "[?namespace=='Microsoft.Web'].{Namespace:namespace, State:registrationState}" --output table
}
