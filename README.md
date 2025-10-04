# Telegram AI Dashboard# 🤖 Telegram AI Dashboard



Sistema automatizado para monitorear grupos de Telegram, extraer URLs de mensajes, procesar contenido web (titulos, resumenes, imagenes) y publicar en un dashboard visual con actualizacion automatica.Sistema automatizado para monitorear grupos de Telegram, extraer URLs de mensajes, procesar contenido web (títulos, resúmenes, imágenes) y publicar en un dashboard visual con actualización automática.



---## ✨ Características



## Inicio Rapido (Un solo comando)- 🔍 **Monitoreo automático** de grupos de Telegram cada 5 minutos

- 🌐 **Extracción inteligente** de contenido web con múltiples estrategias

### Windows- 🤖 **Manejo anti-bot** con Playwright para sitios protegidos (doble fallback)

- 🖼️ **Imágenes inteligentes** con 5 estrategias de fallback + generación

**Opcion 1:** Doble click en `START.bat`- 📊 **Dashboard profesional** responsive (móvil, tablet, desktop)

- 🎯 **Filtros dinámicos** por tipo de contenido (Top 5 + "Otros")

**Opcion 2:** PowerShell- 🔄 **Detección de duplicados** automática por URL

```powershell- 📅 **Preservación de fechas** originales de los mensajes

.\start.ps1- ⚡ **Actualización manual** con botón en el dashboard

```- 🎨 **Diseño profesional** con colores corporativos



### macOS / Linux## � Inicio Rápido (Recomendado)



```bash### Windows

chmod +x start.sh1. **Doble click** en `START.bat`

./start.sh   

```   O en PowerShell:

   ```powershell

### Que hace el script?   .\start.ps1

   ```

El script automaticamente:

- Verifica Python 3.8+### macOS / Linux

- Instala todas las dependencias```bash

- Configura navegadores de Playwrightchmod +x start.sh

- Verifica/crea archivo `.env` con credenciales./start.sh

- Inicia el backend Flask en nueva ventana```

- Abre el dashboard en tu navegador

El script automáticamente:

**Dashboard disponible en:** http://localhost:5000- ✅ Verifica Python

- ✅ Instala todas las dependencias

---- ✅ Configura Playwright

- ✅ Inicia el backend Flask

## Caracteristicas Principales- ✅ Abre el dashboard en tu navegador



- **Monitoreo automatico** cada 5 minutos de grupos de Telegram**📖 Para más detalles, consulta [QUICKSTART.md](QUICKSTART.md)**

- **Extraccion inteligente** de contenido con multiples estrategias

- **Manejo anti-bot** con Playwright (doble fallback)## �📋 Requisitos Previos

- **Imagenes inteligentes** con 5+ estrategias de fallback

- **Dashboard profesional** responsive (movil, tablet, desktop)- Python 3.8+ (recomendado 3.12+)

- **Filtros dinamicos** por tipo de contenido (Top 5 + "Otros")- Credenciales de Telegram API ([obtenerlas aquí](https://my.telegram.org/auth))

- **Deteccion de duplicados** automatica por URL- Windows PowerShell / macOS / Linux

- **Actualizacion manual** con boton "Actualizar"

- **Diseno profesional** con colores corporativos## 🔧 Configuración (Primera vez)



---### 1. Clonar el repositorio



## Documentacion```bash

git clone https://github.com/JoseTapiaUex/telegram-monitor-mcp.git

Toda la documentacion esta organizada en la carpeta **`docs/`**:cd telegram-monitor-mcp

```

| Documento | Descripcion |

|-----------|-------------|### 2. Configurar credenciales de Telegram

| **[QUICKSTART.md](docs/QUICKSTART.md)** | Guia completa de inicio y troubleshooting |

| **[SECURITY.md](docs/SECURITY.md)** | Guia de seguridad y manejo de credenciales |El script de inicio creará automáticamente `.env` desde `.env.example`. Edítalo con tus datos:

| **[PRE-COMMIT-CHECKLIST.md](docs/PRE-COMMIT-CHECKLIST.md)** | Checklist antes de hacer commits |

```bash

---# Windows

notepad .env

## Requisitos

# macOS/Linux

- **Python 3.8+** (recomendado 3.12+)nano .env

- **Credenciales de Telegram API** ([obtenerlas aqui](https://my.telegram.org/auth))```

- **Sistema operativo:** Windows, macOS o Linux

Configura:

---

```env

## Configuracion Inicial# Telegram API credentials

TG_APP_ID=your_app_id_here

### 1. Clonar el repositorioTG_API_HASH=your_api_hash_here

TG_PHONE=+34627733998

```bash

git clone https://github.com/JoseTapiaUex/telegram-monitor-mcp.git# Telegram group to monitor

cd telegram-monitor-mcpTELEGRAM_GROUP_ID=-4945424696

```

# Use Anthropic API (optional, currently disabled)

### 2. Configurar credenciales de TelegramUSE_ANTHROPIC=false

```

El script de inicio creara automaticamente `.env` desde `.env.example`. Editalo con tus datos:

**Obtener credenciales de Telegram:**

```bash1. Ir a https://my.telegram.org

# Windows2. Iniciar sesión con tu número de teléfono

notepad .env3. Ir a "API Development Tools"

4. Crear una nueva aplicación

# macOS/Linux5. Copiar `api_id` y `api_hash`

nano .env

```**Obtener ID del grupo a monitorear:**

```powershell

Configura las siguientes variables:# Ejecutar herramienta auxiliar para listar todos tus chats

python mcp_integration/list_dialogs.py

```env```

# Credenciales de Telegram APIEsto mostrará una tabla con todos tus chats y sus IDs. Copia el ID del grupo que quieres monitorear y úsalo en `TELEGRAM_GROUP_ID`.

TG_APP_ID=tu_app_id_aqui

TG_API_HASH=tu_api_hash_aqui### 5. Primera autenticación con Telegram

TG_PHONE=+34123456789

La primera vez que ejecutes el monitor, te pedirá un código de verificación que Telegram enviará a tu cuenta:

# ID del grupo a monitorear

TELEGRAM_GROUP_ID=-1234567890```powershell

python mcp_integration/telegram_mcp.py

# Usar Anthropic API (opcional, actualmente deshabilitado)```

USE_ANTHROPIC=false

```Ingresa el código cuando se solicite. Esto creará un archivo de sesión (`telegram_dashboard_session.session`) para futuras ejecuciones.



**Obtener credenciales de Telegram:**## 🚀 Uso

1. Visita https://my.telegram.org/auth

2. Inicia sesion con tu numero de telefono### Iniciar el backend

3. Ve a "API Development Tools"

4. Crea una nueva aplicacion```powershell

5. Copia `api_id` y `api_hash`# Desde la raíz del proyecto

python backend/app.py

**Obtener ID del grupo:**```



```bashEl servidor Flask estará disponible en `http://localhost:5000`

# Ejecutar utilidad para listar todos tus chats

python mcp_integration/list_dialogs.py### Ejecutar el monitor de Telegram

```

Opción 1 - Script PowerShell (recomendado):

Esto mostrara una tabla con todos tus chats y sus IDs. Copia el ID del grupo que quieres monitorear.```powershell

.\run_monitor.ps1

### 3. Ejecutar el sistema```



```powershellOpción 2 - Comando directo:

# Windows```powershell

.\start.ps1$env:PYTHONIOENCODING='utf-8'

python mcp_integration/telegram_mcp.py

# macOS/Linux```

./start.sh

```### Ver el dashboard



La primera vez, Telegram te pedira un codigo de autenticacion que recibiras en tu app de Telegram.Abrir en el navegador: `http://localhost:5000`



---El dashboard se actualiza automáticamente cada 30 segundos.



## Arquitectura del Sistema## 📁 Estructura del Proyecto



``````

┌─────────────────┐telegram-ai-dashboard/

│   Dashboard     │  ← Frontend SPA (HTML/CSS/JS)├── .env                          # Variables de entorno (no incluido en git)

│  localhost:5000 │├── .gitignore                    # Archivos ignorados por git

└────────┬────────┘├── requirements.txt              # Dependencias de Python

         │ API REST├── run_monitor.ps1              # Script para ejecutar el monitor

         ▼├── README.md                    # Este archivo

┌─────────────────┐│

│  Flask Backend  │  ← Servidor Python├── backend/

│   Port 5000     ││   ├── app.py                   # API Flask (servidor backend)

└────────┬────────┘│   ├── posts.db                 # Base de datos SQLite

         ││   └── requirements.txt         # Dependencias específicas del backend

         ├─► SQLite Database (posts.db)│

         │├── frontend/

         └─► Telegram Monitor (telegram_mcp.py)│   └── index.html               # Dashboard visual (SPA)

                    ││

                    ├─► Telegram API (telethon)└── mcp_integration/

                    └─► Web Scraping (BeautifulSoup + Playwright)    ├── telegram_mcp.py          # Monitor principal de Telegram

```    └── monitor_state.json       # Estado del monitor (último mensaje procesado)

```

---

## 🔄 Flujo de Funcionamiento

## Estructura del Proyecto

1. **Monitor de Telegram** (`telegram_mcp.py`):

```   - Se conecta al grupo de Telegram usando `telethon`

telegram-ai-dashboard/   - Lee mensajes nuevos desde el último procesado

├── START.bat              # Launcher Windows (doble click)   - Extrae URLs de los mensajes

├── start.ps1              # Script de inicio (Windows)   - Procesa cada URL para extraer contenido

├── start.sh               # Script de inicio (macOS/Linux)

├── .env                   # Configuracion (no incluido en git)2. **Extracción de Contenido** (multi-estrategia):

├── .env.example           # Plantilla de configuracion   - **Intento 1**: Request HTTP normal con headers mejorados

├── requirements.txt       # Dependencias principales   - **Intento 2**: Si detecta anti-bot (status 202/403), usa Playwright con navegador real

│   - Extrae: título, resumen, imagen, proveedor, tipo de contenido

├── backend/   - Clasifica contenido: Noticia, Artículo, Blog, Red Social, Investigación, Video

│   ├── app.py               # Servidor Flask (API REST)

│   ├── requirements.txt     # Dependencias del backend3. **Backend Flask** (`app.py`):

│   └── posts.db            # Base de datos SQLite   - Recibe posts del monitor vía API REST

│   - Valida y detecta duplicados por URL

├── frontend/   - Almacena en SQLite (`backend/posts.db`)

│   └── index.html          # Dashboard SPA   - Sirve API para el frontend

│

├── mcp_integration/4. **Frontend** (`index.html`):

│   ├── telegram_mcp.py     # Monitor de Telegram   - Consulta API cada 30 segundos

│   └── list_dialogs.py     # Utilidad para listar grupos   - Muestra posts en grid visual

│   - Soporta imágenes reales o generadas (DiceBear)

└── docs/                    # Documentacion completa

    ├── QUICKSTART.md## 🛠️ Tecnologías Utilizadas

    ├── SECURITY.md

    └── PRE-COMMIT-CHECKLIST.md### Backend

```- **Flask 3.1.2** - Framework web

- **Flask-CORS 6.0.1** - Cross-Origin Resource Sharing

---- **SQLite** - Base de datos embebida



## Endpoints de la API### Scraping & Parsing

- **Telethon 1.41.2** - Cliente de Telegram

### `GET /api/posts`- **Requests 2.32.4** - HTTP client

Retorna todos los posts ordenados por fecha (mas recientes primero)- **BeautifulSoup4 4.13.5** - Parsing HTML

- **lxml 6.0.2** - Parser XML/HTML de alto rendimiento

**Response:**- **Playwright 1.55.0** - Browser automation para anti-bot

```json

[### Utilidades

  {- **python-dotenv 1.1.1** - Manejo de variables de entorno

    "id": 1,

    "title": "Titulo del post",## 🎨 Estrategias de Extracción

    "summary": "Resumen del contenido",

    "source_url": "https://ejemplo.com",### Títulos

    "image_url": "https://imagen.com/img.jpg",1. Open Graph (`og:title`)

    "release_date": "2025-10-04",2. Twitter Card (`twitter:title`)

    "provider": "ejemplo.com",3. Tag `<title>`

    "type": "Articulo",4. Primera etiqueta `<h1>`

    "created_at": "2025-10-04 10:30:00"5. Fallback: nombre del dominio

  }

]### Resúmenes

```1. Open Graph (`og:description`)

2. Twitter Card (`twitter:description`)

### `POST /api/refresh`3. Meta description

Ejecuta el monitor de Telegram para buscar nuevos posts4. Primer párrafo de `<article>`, `<main>` o `<p>`

5. Fallback: mensaje genérico

**Response:**

```json### Imágenes

{1. Open Graph (`og:image`)

  "success": true,2. Twitter Card (`twitter:image`)

  "message": "Monitor ejecutado correctamente",3. `<link rel="image_src">`

  "total_posts": 154. Primera imagen `<img>` de tamaño sustancial

}5. Fallback: generación con DiceBear API

```

### Sitios Especiales

---- **X.com/Twitter**: Extractor específico para meta tags de Twitter

- **Sitios protegidos**: Detección automática y uso de Playwright

## Caracteristicas del Dashboard

## 🔒 Seguridad

### Auto-refresh Inteligente

- Cada 5 minutos busca automaticamente nuevos posts en Telegram### Archivos Protegidos por `.gitignore`

- Boton "Actualizar" para busqueda manual instantanea

- Estadisticas en tiempo real (total posts, posts de hoy, ultima actualizacion)El proyecto incluye protección completa de información sensible:



### Filtros Dinamicos- 🔴 **`.env`** - Credenciales de Telegram API y API keys (CRÍTICO)

- Filtros generados automaticamente segun los tipos de contenido- 🔴 **`*.session`** - Sesiones autenticadas de Telegram (CRÍTICO)

- Top 5 categorias mas representadas + filtro "Otros"- 🟠 **`*.db`** - Bases de datos con posts y metadatos

- Contador de posts por cada categoria- 🟡 **`monitor_state.json`** - Estado del monitor (IDs de mensajes)

- Iconos personalizados por tipo- ⚪ **`__pycache__/`** - Cache de Python



### Sistema de Imagenes### ⚠️ NUNCA Subir a Git

Fallback inteligente con multiples fuentes:

1. Imagen real extraida del sitio web**Archivos críticos que NUNCA deben estar en el repositorio:**

2. Picsum Photos (fotos reales con seed)- ❌ Tu archivo `.env` con credenciales reales

3. Vercel Avatar (avatares estilizados)- ❌ Archivos de sesión de Telegram (`*.session`)

4. UI Avatars (iniciales + colores personalizados)- ❌ Tokens o API keys

5. Boring Avatars (disenos geometricos)- ❌ Base de datos con contenido real (`*.db`)

6. SVG con gradiente (ultimo recurso garantizado)

**Usa `.env.example` como plantilla** (este SÍ puede ir en git)

### Responsive Design

- **Movil** (< 768px): 1 columna### 📖 Guía Completa de Seguridad

- **Tablet** (768-1279px): 2 columnas

- **Desktop** (>= 1280px): 3 columnasPara información detallada sobre:

- Header con imagen de fondo espacial- Qué hacer si expusiste credenciales por error

- Dark mode automatico segun preferencias del sistema- Cómo rotar API keys

- Mejores prácticas de seguridad

---- Checklist antes de hacer commit



## Tecnologias Utilizadas**→ Consulta [SECURITY.md](./SECURITY.md)**



### Backend## 📝 Estado del Monitor

- **Python 3.12**

- **Flask 3.1.2** - Framework webEl archivo `mcp_integration/monitor_state.json` guarda el ID del último mensaje procesado para evitar duplicados en futuras ejecuciones:

- **Telethon 1.41.2** - Cliente de Telegram API

- **BeautifulSoup4 4.13.5** - Parsing HTML/XML```json

- **Playwright 1.55.0** - Automatizacion de navegador{

- **SQLite** - Base de datos embebida  "last_message_id": 12345

}

### Frontend```

- **HTML5 + CSS3** - Estructura y estilos

- **JavaScript ES6+** - Logica del dashboardPara reprocesar todos los mensajes desde el inicio, simplemente elimina este archivo.

- **Fetch API** - Comunicacion con backend

- **CSS Grid + Flexbox** - Layout responsive## 🐛 Troubleshooting



---### Error: "Can't open database file"

- Asegúrate de que el directorio `backend/` existe

## Solucion de Problemas- Verifica permisos de escritura



### Error: Python no encontrado### Error: "Chromium downloadable not found"

```bash- Ejecuta: `python -m playwright install chromium`

# Windows

# Instala desde: https://www.python.org/downloads/### Error: Unicode en PowerShell

- El script `run_monitor.ps1` ya incluye `$env:PYTHONIOENCODING='utf-8'`

# macOS- Si ejecutas manualmente, siempre usa este prefijo

brew install python3

### Backend no responde

# Linux- Verifica que Flask esté corriendo: `Get-Process python`

sudo apt install python3 python3-pip- Verifica el puerto: `Get-NetTCPConnection -LocalPort 5000`

```- Reinicia el servidor



### Error: Puerto 5000 ya en uso### No se procesan mensajes nuevos

```powershell- Elimina `monitor_state.json` para resetear

# Windows- Verifica las credenciales en `.env`

taskkill /F /IM python.exe- Revisa que el grupo esté correctamente identificado



# macOS/Linux## 🔮 Mejoras Futuras

kill -9 $(lsof -ti:5000)

```- [ ] Ejecución programada con Task Scheduler

- [ ] Soporte para múltiples grupos

### Error: Playwright no funciona- [ ] Panel de administración

```bash- [ ] Filtros y búsqueda en el dashboard

playwright install chromium- [ ] Exportación de datos (JSON, CSV)

```- [ ] Notificaciones de nuevos posts

- [ ] Integración opcional con Claude API para resúmenes mejorados

### Error: No se pueden instalar dependencias- [ ] Docker containerization

```bash- [ ] Deployment en cloud (Heroku, Railway, etc.)

# Actualizar pip

python -m pip install --upgrade pip## 📄 Licencia



# Reinstalar dependenciasEste proyecto es de código abierto. Úsalo libremente para aprender y construir.

pip install -r requirements.txt --force-reinstall

```## 👤 Autor



### Mas ayuda**Jose Tapia**

Consulta **[docs/QUICKSTART.md](docs/QUICKSTART.md)** para troubleshooting detallado.- GitHub: [@JoseTapiaUex](https://github.com/JoseTapiaUex)

- Repositorio: [telegram-monitor-mcp](https://github.com/JoseTapiaUex/telegram-monitor-mcp)

---

## 🤝 Contribuciones

## Seguridad

Las contribuciones son bienvenidas. Por favor:

- Las credenciales se almacenan en `.env` (no incluido en git)1. Haz fork del proyecto

- `.gitignore` protege archivos sensibles (*.env, *.session, *.db)2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)

- Consulta **[docs/SECURITY.md](docs/SECURITY.md)** para mejores practicas3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)

- Usa **[docs/PRE-COMMIT-CHECKLIST.md](docs/PRE-COMMIT-CHECKLIST.md)** antes de commits4. Push a la rama (`git push origin feature/AmazingFeature`)

5. Abre un Pull Request

---

---

## Roadmap

⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub

### Proximas funcionalidades
- [ ] Busqueda de texto completo en posts
- [ ] Filtros por fecha (hoy, semana, mes)
- [ ] Filtros por proveedor/fuente
- [ ] Exportar posts a CSV/JSON
- [ ] Modo oscuro manual (toggle)
- [ ] Autenticacion de usuarios
- [ ] Multiples grupos de Telegram
- [ ] Notificaciones push

---

## Licencia

Este proyecto es de codigo abierto. Sientete libre de usarlo, modificarlo y distribuirlo.

---

## Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Revisa **[docs/PRE-COMMIT-CHECKLIST.md](docs/PRE-COMMIT-CHECKLIST.md)**
4. Commit tus cambios (`git commit -m 'Add AmazingFeature'`)
5. Push a la rama (`git push origin feature/AmazingFeature`)
6. Abre un Pull Request

---

## Autor

**Jose Tapia**
- GitHub: [@JoseTapiaUex](https://github.com/JoseTapiaUex)
- Repositorio: [telegram-monitor-mcp](https://github.com/JoseTapiaUex/telegram-monitor-mcp)

---

## Agradecimientos

Desarrollado con Python, Flask, Telethon y Playwright.

---

**Preguntas o problemas?** Abre un [issue](https://github.com/JoseTapiaUex/telegram-monitor-mcp/issues) en GitHub.
