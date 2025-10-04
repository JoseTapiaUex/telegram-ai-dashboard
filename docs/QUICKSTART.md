# 🚀 Guía de Inicio Rápido

## Inicio Automático (Recomendado)

### Windows
```powershell
.\start.ps1
```

### macOS / Linux
```bash
chmod +x start.sh
./start.sh
```

## ¿Qué hace el script de inicio?

El script `start.ps1` (Windows) o `start.sh` (macOS/Linux) realiza automáticamente:

1. ✅ **Verifica Python** - Comprueba que Python 3.8+ esté instalado
2. ✅ **Instala dependencias** - Ejecuta `pip install -r requirements.txt` automáticamente
3. ✅ **Configura Playwright** - Instala navegadores necesarios para scraping
4. ✅ **Verifica configuración** - Comprueba que `.env` exista (lo crea desde `.env.example` si no existe)
5. ✅ **Inicia backend** - Lanza Flask en una nueva ventana/terminal
6. ✅ **Abre el dashboard** - Abre http://localhost:5000 en tu navegador predeterminado

## Primera vez (Configuración inicial)

Si es la primera vez que ejecutas el proyecto:

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/JoseTapiaUex/telegram-monitor-mcp.git
   cd telegram-monitor-mcp
   ```

2. **Configura las credenciales de Telegram**
   
   El script creará automáticamente `.env` desde `.env.example`. Edita `.env` con tus credenciales:
   
   ```bash
   # Windows
   notepad .env
   
   # macOS/Linux
   nano .env
   ```
   
   Configura:
   - `TG_APP_ID` - Tu App ID de Telegram
   - `TG_API_HASH` - Tu API Hash de Telegram
   - `TG_PHONE` - Tu número de teléfono (con código de país)
   - `TELEGRAM_GROUP_ID` - ID del grupo a monitorear

   ℹ️ **Obtener credenciales**: https://my.telegram.org/auth

3. **Ejecuta el script de inicio**
   ```powershell
   # Windows
   .\start.ps1
   
   # macOS/Linux
   chmod +x start.sh
   ./start.sh
   ```

## Inicio Manual (Avanzado)

Si prefieres controlar cada paso manualmente:

### 1. Instalar dependencias
```bash
pip install -r requirements.txt
pip install -r backend/requirements.txt
playwright install chromium
```

### 2. Iniciar backend
```bash
cd backend
python app.py
```

### 3. Abrir dashboard
Navega a http://localhost:5000 en tu navegador

## Dashboard

Una vez iniciado, el dashboard estará disponible en:

**🌐 http://localhost:5000**

### Características del Dashboard:

- ✨ **Auto-refresh cada 5 minutos** - Busca nuevos posts automáticamente
- 🔄 **Botón "Actualizar"** - Busca posts manualmente cuando quieras
- 🎯 **Filtros dinámicos** - Filtra por tipo de contenido (Top 5 + "Otros")
- 📊 **Estadísticas** - Total de posts, posts del día, última actualización
- 📱 **Responsive** - Funciona en móvil, tablet y desktop
- 🎨 **Imágenes inteligentes** - Sistema de fallback con múltiples fuentes

## Detener el sistema

### Windows
- Cierra la ventana del backend (PowerShell con Flask)
- O presiona `Ctrl+C` en la terminal del backend

### macOS/Linux
```bash
# Detener el backend
kill -9 $(lsof -ti:5000)
```

## Solución de problemas

### Error: Python no encontrado
**Windows**: Instala Python desde https://www.python.org/downloads/
**macOS**: `brew install python3`
**Linux**: `sudo apt install python3 python3-pip`

### Error: Puerto 5000 ya en uso
```powershell
# Windows
taskkill /F /IM python.exe

# macOS/Linux
kill -9 $(lsof -ti:5000)
```

### Error: Playwright no funciona
```bash
playwright install chromium
```

### Error: No se pueden instalar dependencias
```bash
# Actualizar pip
python -m pip install --upgrade pip

# Reinstalar dependencias
pip install -r requirements.txt --force-reinstall
```

## Estructura del Proyecto

```
telegram-ai-dashboard/
├── start.ps1              # Script de inicio (Windows)
├── start.sh               # Script de inicio (macOS/Linux)
├── run_monitor.ps1        # Script legacy (solo ejecuta monitor)
├── .env                   # Configuración (no incluido en git)
├── .env.example           # Plantilla de configuración
├── requirements.txt       # Dependencias principales
├── backend/
│   ├── app.py            # Servidor Flask (API + endpoints)
│   ├── requirements.txt  # Dependencias del backend
│   └── posts.db          # Base de datos SQLite
├── frontend/
│   └── index.html        # Dashboard SPA (HTML+CSS+JS)
└── mcp_integration/
    ├── telegram_mcp.py   # Monitor de Telegram (scraping)
    └── list_dialogs.py   # Utilidad para listar grupos
```

## Arquitectura

```
┌─────────────────┐
│   Dashboard     │ (frontend/index.html)
│  http://5000    │
└────────┬────────┘
         │ GET /api/posts
         │ POST /api/refresh
         ▼
┌─────────────────┐
│  Flask Backend  │ (backend/app.py)
│   Port 5000     │
└────────┬────────┘
         │
         ├─► SQLite (backend/posts.db)
         │
         └─► Ejecuta telegram_mcp.py
                   ▼
         ┌─────────────────┐
         │ Telegram API    │
         │ (telethon)      │
         └────────┬────────┘
                  │
         ┌────────▼────────┐
         │  Web Scraping   │
         │ (BeautifulSoup  │
         │  + Playwright)  │
         └─────────────────┘
```

## Endpoints de la API

### `GET /api/posts`
Retorna todos los posts ordenados por fecha (más recientes primero)

**Response:**
```json
[
  {
    "id": 1,
    "title": "Título del post",
    "summary": "Resumen del contenido",
    "source_url": "https://ejemplo.com",
    "image_url": "https://imagen.com/img.jpg",
    "release_date": "2025-10-04",
    "provider": "ejemplo.com",
    "type": "Artículo",
    "created_at": "2025-10-04 10:30:00"
  }
]
```

### `POST /api/refresh`
Ejecuta el monitor de Telegram para buscar nuevos posts

**Response:**
```json
{
  "success": true,
  "message": "Monitor ejecutado correctamente",
  "total_posts": 15,
  "output": "...",
  "errors": ""
}
```

## Próximos pasos

- [ ] Dockerizar el proyecto
- [ ] Agregar autenticación
- [ ] Exportar posts a CSV/JSON
- [ ] Notificaciones push para nuevos posts
- [ ] Modo oscuro en el dashboard
- [ ] Búsqueda de texto completo
- [ ] Filtros por fecha y proveedor

## Soporte

Si encuentras problemas:
1. Revisa la sección "Solución de problemas"
2. Consulta `SECURITY.md` para temas de seguridad
3. Revisa `PRE-COMMIT-CHECKLIST.md` antes de hacer commits
4. Abre un issue en GitHub

---

**Desarrollado con ❤️ usando Python, Flask, Telethon y Playwright**
