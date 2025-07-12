# 📋 PRZEWODNIK KROK PO KROKU - GitHub Secrets

## Co masz zrobić TERAZ:

### Krok 1: Pobierz Publish Profiles (jeśli jeszcze nie masz)

**Opcja A - Azure Portal:**
1. Idź na https://portal.azure.com
2. Wyszukaj "azure-crud-rg"
3. Dla każdej aplikacji (backend i frontend):
   - Kliknij na aplikację
   - Znajdź "Get publish profile" 
   - Pobierz plik .publishsettings
   - Otwórz w notatniku i skopiuj całość

**Opcja B - Z terminala (jeśli komendy się wykonały):**
Skopiuj wyniki komend z terminala VS Code.

### Krok 2: Dodaj Secrets w GitHub

1. **Otwórz**: https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai
2. **Kliknij**: Settings (zakładka na górze)
3. **Znajdź**: Secrets and variables → Actions (lewe menu)
4. **Dodaj pierwszy secret**:
   ```
   Name: AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND
   Value: [Wklej cały XML z backend publish profile]
   ```
5. **Dodaj drugi secret**:
   ```
   Name: AZURE_WEBAPP_PUBLISH_PROFILE_FRONTEND  
   Value: [Wklej cały XML z frontend publish profile]
   ```

### Krok 3: Test Deployment

Po dodaniu secrets:
1. Idź do zakładki "Actions" w GitHub repo
2. Znajdź workflow "Deploy to Azure App Service"
3. Kliknij "Run workflow" aby uruchomić ręcznie
4. Obserwuj deployment w czasie rzeczywistym

## ⚠️ UWAGI:
- XML musi być skopiowany CAŁKOWICIE (od <?xml do końca)
- Nazwy secrets muszą być DOKŁADNIE takie jak podane
- Nie dodawaj spacji przed/po XML

## 🔗 Przydatne linki:
- Azure Portal: https://portal.azure.com
- Twój GitHub repo: https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai
- GitHub Actions: https://github.com/BartlomiejSzczotka/azure_crud_app_agent_ai/actions

## 📱 URLs twoich aplikacji (po deployment):
- Backend: https://azure-crud-backend-app.azurewebsites.net
- Frontend: https://azure-crud-frontend-app.azurewebsites.net
