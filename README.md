# Telegram AI Dashboard# Telegram AI Dashboard# 🤖 Telegram AI Dashboard



Sistema automatizado de monitoreo y analisis de contenido de grupos de Telegram con interfaz web profesional.



## Inicio RapidoSistema automatizado para monitorear grupos de Telegram, extraer URLs de mensajes, procesar contenido web (titulos, resumenes, imagenes) y publicar en un dashboard visual con actualizacion automatica.Sistema automatizado para monitorear grupos de Telegram, extraer URLs de mensajes, procesar contenido web (títulos, resúmenes, imágenes) y publicar en un dashboard visual con actualización automática.



### Windows



```powershell---## ✨ Características

# 1. Clonar el repositorio

git clone https://github.com/JoseTapiaUex/telegram-ai-dashboard.git

cd telegram-ai-dashboard

## Inicio Rapido (Un solo comando)- 🔍 **Monitoreo automático** de grupos de Telegram cada 5 minutos

# 2. Ejecutar el script de inicio (configuracion automatica)

.\start.ps1- 🌐 **Extracción inteligente** de contenido web con múltiples estrategias

```

### Windows- 🤖 **Manejo anti-bot** con Playwright para sitios protegidos (doble fallback)

### macOS / Linux

- 🖼️ **Imágenes inteligentes** con 5 estrategias de fallback + generación

```bash

# 1. Clonar el repositorio**Opcion 1:** Doble click en `START.bat`- 📊 **Dashboard profesional** responsive (móvil, tablet, desktop)

git clone https://github.com/JoseTapiaUex/telegram-ai-dashboard.git

cd telegram-ai-dashboard- 🎯 **Filtros dinámicos** por tipo de contenido (Top 5 + "Otros")



# 2. Dar permisos de ejecucion y ejecutar**Opcion 2:** PowerShell- 🔄 **Detección de duplicados** automática por URL

chmod +x start.sh

./start.sh```powershell- 📅 **Preservación de fechas** originales de los mensajes

```

.\start.ps1- ⚡ **Actualización manual** con botón en el dashboard

El script de inicio se encargara de:

- Configuracion interactiva (si es tu primera vez)```- 🎨 **Diseño profesional** con colores corporativos

- Instalacion automatica de dependencias

- Inicio del backend Flask

- Apertura del dashboard en tu navegador

### macOS / Linux## � Inicio Rápido (Recomendado)

## Configuracion Interactiva



Si es tu primera vez, el sistema te guiara paso a paso para crear tu archivo `.env`:

```bash### Windows

### Paso 1: Credenciales de Telegram API

chmod +x start.sh1. **Doble click** en `START.bat`

1. Ve a [https://my.telegram.org/auth](https://my.telegram.org/auth)

2. Inicia sesion con tu numero de telefono./start.sh   

3. Ve a "API Development Tools"

4. Crea una nueva aplicacion```   O en PowerShell:

5. Copia `api_id` y `api_hash`

   ```powershell

### Paso 2: Identificacion Automatica de Grupos

### Que hace el script?   .\start.ps1

El sistema se conectara a Telegram y mostrara una tabla con todos tus grupos y canales, incluyendo:

- ID del grupo (necesario para el monitoreo)   ```

- Nombre del grupo

- Numero de participantesEl script automaticamente:



### Paso 3: Seleccion de Grupo- Verifica Python 3.8+### macOS / Linux



Simplemente copia el ID del grupo que quieres monitorear de la tabla mostrada.- Instala todas las dependencias```bash



### Paso 4: Configuracion Opcional- Configura navegadores de Playwrightchmod +x start.sh



- Opcionalmente puedes habilitar Anthropic API para mejorar los resumenes con Claude AI- Verifica/crea archivo `.env` con credenciales./start.sh

- Por defecto esta funcionalidad esta deshabilitada

- Inicia el backend Flask en nueva ventana```

**Nota:** Tu archivo `.env` esta protegido por `.gitignore` y nunca se subira a GitHub.

- Abre el dashboard en tu navegador

## Caracteristicas Principales

El script automáticamente:

- **Monitoreo Automatico**: Busqueda programada de nuevos posts en grupos de Telegram

- **Dashboard Profesional**: Interfaz web responsive con diseno moderno**Dashboard disponible en:** http://localhost:5000- ✅ Verifica Python

- **Filtros Inteligentes**: Filtra posts por tipo, fecha y otras categorias

- **Imagenes Optimizadas**: Sistema de fallback multiple para mostrar imagenes siempre- ✅ Instala todas las dependencias

- **Actualizacion Manual**: Boton para refrescar y buscar nuevos posts inmediatamente

- **Auto-Refresh**: Actualizacion automatica cada 5 minutos---- ✅ Configura Playwright

- **Diseno Responsive**: Adaptacion automatica a diferentes tamanos de pantalla (1/2/3 columnas)

- **Soporte Android**: Optimizado para navegacion movil- ✅ Inicia el backend Flask

- **Anti-Bot**: Manejo automatico de captchas y protecciones anti-bot

## Caracteristicas Principales- ✅ Abre el dashboard en tu navegador

## Documentacion Completa



| Documento | Descripcion |

|-----------|-------------|- **Monitoreo automatico** cada 5 minutos de grupos de Telegram**📖 Para más detalles, consulta [QUICKSTART.md](QUICKSTART.md)**

| [QUICKSTART.md](docs/QUICKSTART.md) | Guia detallada de instalacion y configuracion |

| [SECURITY.md](docs/SECURITY.md) | Mejores practicas de seguridad |- **Extraccion inteligente** de contenido con multiples estrategias

| [PRE-COMMIT-CHECKLIST.md](docs/PRE-COMMIT-CHECKLIST.md) | Verificacion antes de commits |

- **Manejo anti-bot** con Playwright (doble fallback)## �📋 Requisitos Previos

## Requisitos

- **Imagenes inteligentes** con 5+ estrategias de fallback

- **Python 3.8+** (recomendado 3.12)

- **Credenciales de Telegram API** ([my.telegram.org](https://my.telegram.org))- **Dashboard profesional** responsive (movil, tablet, desktop)- Python 3.8+ (recomendado 3.12+)

- **Navegador moderno** (Chrome, Firefox, Edge, Safari)

- **Sistemas operativos**: Windows 10/11, macOS 10.15+, Linux- **Filtros dinamicos** por tipo de contenido (Top 5 + "Otros")- Credenciales de Telegram API ([obtenerlas aquí](https://my.telegram.org/auth))



## Arquitectura- **Deteccion de duplicados** automatica por URL- Windows PowerShell / macOS / Linux



```- **Actualizacion manual** con boton "Actualizar"

┌─────────────┐      HTTP      ┌──────────────┐      Telethon      ┌──────────┐

│   Browser   │ ←──────────────→│ Flask Server │ ←──────────────────→│ Telegram │- **Diseno profesional** con colores corporativos## 🔧 Configuración (Primera vez)

│  (Frontend) │   REST API     │  (Backend)   │   API Client       │   API    │

└─────────────┘                 └──────────────┘                     └──────────┘

                                       │

                                       ↓---### 1. Clonar el repositorio

                                  ┌─────────┐

                                  │ SQLite  │

                                  │Database │

                                  └─────────┘## Documentacion```bash

```

git clone https://github.com/JoseTapiaUex/telegram-monitor-mcp.git

## Estructura del Proyecto

Toda la documentacion esta organizada en la carpeta **`docs/`**:cd telegram-monitor-mcp

```

telegram-ai-dashboard/```

├── backend/

│   ├── app.py                 # Servidor Flask + REST API| Documento | Descripcion |

│   ├── requirements.txt       # Dependencias del backend

│   └── posts.db              # Base de datos SQLite (generada)|-----------|-------------|### 2. Configurar credenciales de Telegram

├── frontend/

│   └── index.html            # Dashboard SPA| **[QUICKSTART.md](docs/QUICKSTART.md)** | Guia completa de inicio y troubleshooting |

├── mcp_integration/

│   ├── telegram_mcp.py       # Script de monitoreo principal| **[SECURITY.md](docs/SECURITY.md)** | Guia de seguridad y manejo de credenciales |El script de inicio creará automáticamente `.env` desde `.env.example`. Edítalo con tus datos:

│   └── list_dialogs.py       # Listador de grupos/canales

├── docs/| **[PRE-COMMIT-CHECKLIST.md](docs/PRE-COMMIT-CHECKLIST.md)** | Checklist antes de hacer commits |

│   ├── QUICKSTART.md         # Guia de inicio

│   ├── SECURITY.md           # Seguridad```bash

│   └── PRE-COMMIT-CHECKLIST.md

├── .env                      # Configuracion (generado, no en Git)---# Windows

├── .gitignore

├── setup_env.ps1             # Configuracion interactiva (Windows)notepad .env

├── setup_env.sh              # Configuracion interactiva (macOS/Linux)

├── start.ps1                 # Script de inicio (Windows)## Requisitos

├── start.sh                  # Script de inicio (macOS/Linux)

├── START.bat                 # Atajo de inicio rapido (Windows)# macOS/Linux

└── README.md

```- **Python 3.8+** (recomendado 3.12+)nano .env



## Endpoints API- **Credenciales de Telegram API** ([obtenerlas aqui](https://my.telegram.org/auth))```



### GET /api/posts- **Sistema operativo:** Windows, macOS o Linux



Retorna todos los posts almacenados en la base de datos.Configura:



**Response:**---

```json

[```env

  {

    "id": 1,## Configuracion Inicial# Telegram API credentials

    "telegram_id": 123456,

    "author": "Usuario",TG_APP_ID=your_app_id_here

    "content": "Contenido del post",

    "date": "2024-01-15T10:30:00",### 1. Clonar el repositorioTG_API_HASH=your_api_hash_here

    "image_url": "https://...",

    "url": "https://t.me/...",TG_PHONE=+34627733998

    "type": "Noticia",

    "summary": "Resumen automatico"```bash

  }

]git clone https://github.com/JoseTapiaUex/telegram-monitor-mcp.git# Telegram group to monitor

```

cd telegram-monitor-mcpTELEGRAM_GROUP_ID=-4945424696

### POST /api/refresh

```

Ejecuta el script de monitoreo para buscar nuevos posts en Telegram.

# Use Anthropic API (optional, currently disabled)

**Response:**

```json### 2. Configurar credenciales de TelegramUSE_ANTHROPIC=false

{

  "success": true,```

  "total_posts": 25,

  "output": "Monitor execution output...",El script de inicio creara automaticamente `.env` desde `.env.example`. Editalo con tus datos:

  "errors": ""

}**Obtener credenciales de Telegram:**

```

```bash1. Ir a https://my.telegram.org

## Caracteristicas del Dashboard

# Windows2. Iniciar sesión con tu número de teléfono

### Diseno Responsive

notepad .env3. Ir a "API Development Tools"

- **Movil (< 768px)**: 1 columna

- **Tablet (768px - 1200px)**: 2 columnas4. Crear una nueva aplicación

- **Desktop (> 1200px)**: 3 columnas

# macOS/Linux5. Copiar `api_id` y `api_hash`

### Sistema de Imagenes

nano .env

Fallback multiple para garantizar que siempre se muestren imagenes:

```**Obtener ID del grupo a monitorear:**

1. **Imagen original** del post de Telegram

2. **Picsum Photos** - Imagenes aleatorias de alta calidad```powershell

3. **Vercel Avatar** - Avatares generados por beam

4. **UI Avatars** - Avatares con inicialesConfigura las siguientes variables:# Ejecutar herramienta auxiliar para listar todos tus chats

5. **Boring Avatars** - Avatares abstractos generados

6. **SVG Gradient** - Degradados generados por codigopython mcp_integration/list_dialogs.py



Todas las imagenes se asignan consistentemente usando hash del contenido del post.```env```



### Filtros Disponibles# Credenciales de Telegram APIEsto mostrará una tabla con todos tus chats y sus IDs. Copia el ID del grupo que quieres monitorear y úsalo en `TELEGRAM_GROUP_ID`.



- **Top 5 categorias** mas comunes (actualizacion dinamica)TG_APP_ID=tu_app_id_aqui

- **Categoria "Otros"** para el resto

- **"Todos"** para ver posts sin filtrarTG_API_HASH=tu_api_hash_aqui### 5. Primera autenticación con Telegram



### OrdenamientoTG_PHONE=+34123456789



Posts ordenados por fecha, **mas recientes primero**.La primera vez que ejecutes el monitor, te pedirá un código de verificación que Telegram enviará a tu cuenta:



### Header Profesional# ID del grupo a monitorear



- Imagen de fondo con tema espacialTELEGRAM_GROUP_ID=-1234567890```powershell

- Titulo del proyecto

- Colores corporativospython mcp_integration/telegram_mcp.py



## Tecnologias Utilizadas# Usar Anthropic API (opcional, actualmente deshabilitado)```



### BackendUSE_ANTHROPIC=false



- **Python 3.12**```Ingresa el código cuando se solicite. Esto creará un archivo de sesión (`telegram_dashboard_session.session`) para futuras ejecuciones.

- **Flask 3.1.2** - Framework web

- **Flask-CORS 6.0.1** - Manejo de CORS

- **Telethon 1.41.2** - Cliente de Telegram API

- **Playwright 1.55.0** - Automatizacion de navegador para anti-bot**Obtener credenciales de Telegram:**## 🚀 Uso

- **BeautifulSoup4 4.13.5** - Parsing de HTML

- **lxml 6.0.2** - Procesamiento XML/HTML1. Visita https://my.telegram.org/auth

- **SQLite** - Base de datos embebida

2. Inicia sesion con tu numero de telefono### Iniciar el backend

### Frontend

3. Ve a "API Development Tools"

- **HTML5**

- **CSS3** (Grid Layout, Flexbox, Media Queries)4. Crea una nueva aplicacion```powershell

- **JavaScript ES6+** (Fetch API, Async/Await)

- **Responsive Design**5. Copia `api_id` y `api_hash`# Desde la raíz del proyecto



### Scripts de Automatizacionpython backend/app.py



- **PowerShell** (Windows)**Obtener ID del grupo:**```

- **Bash** (macOS/Linux)



## Solucion de Problemas

```bashEl servidor Flask estará disponible en `http://localhost:5000`

### Python no encontrado

# Ejecutar utilidad para listar todos tus chats

**Sintoma:**

```python mcp_integration/list_dialogs.py### Ejecutar el monitor de Telegram

Python no esta instalado o no esta en PATH

``````



**Solucion:**Opción 1 - Script PowerShell (recomendado):

1. Descarga Python 3.8+ desde [python.org](https://www.python.org/downloads/)

2. Durante la instalacion, marca "Add Python to PATH"Esto mostrara una tabla con todos tus chats y sus IDs. Copia el ID del grupo que quieres monitorear.```powershell

3. Reinicia la terminal

4. Verifica con: `python --version`.\run_monitor.ps1



### Puerto 5000 en uso### 3. Ejecutar el sistema```



**Sintoma:**

```

OSError: [Errno 48] Address already in use```powershellOpción 2 - Comando directo:

```

# Windows```powershell

**Solucion:**

.\start.ps1$env:PYTHONIOENCODING='utf-8'

Windows:

```powershellpython mcp_integration/telegram_mcp.py

# Encontrar el proceso usando el puerto 5000

netstat -ano | findstr :5000# macOS/Linux```

# Matar el proceso (reemplaza PID con el numero encontrado)

taskkill /PID <PID> /F./start.sh

```

```### Ver el dashboard

macOS/Linux:

```bash

# Encontrar y matar el proceso

lsof -ti:5000 | xargs kill -9La primera vez, Telegram te pedira un codigo de autenticacion que recibiras en tu app de Telegram.Abrir en el navegador: `http://localhost:5000`

```



### Playwright no instalado

---El dashboard se actualiza automáticamente cada 30 segundos.

**Sintoma:**

```

Executable doesn't exist at /path/to/chromium

```## Arquitectura del Sistema## 📁 Estructura del Proyecto



**Solucion:**

```bash

# Instalar navegadores de Playwright``````

python -m playwright install chromium

┌─────────────────┐telegram-ai-dashboard/

# Si falla, instalar con dependencias del sistema

python -m playwright install --with-deps chromium│   Dashboard     │  ← Frontend SPA (HTML/CSS/JS)├── .env                          # Variables de entorno (no incluido en git)

```

│  localhost:5000 │├── .gitignore                    # Archivos ignorados por git

### list_dialogs.py no muestra grupos

└────────┬────────┘├── requirements.txt              # Dependencias de Python

**Sintoma:**

El script se ejecuta pero no muestra ningun grupo.         │ API REST├── run_monitor.ps1              # Script para ejecutar el monitor



**Solucion:**         ▼├── README.md                    # Este archivo

1. Verifica que tu cuenta de Telegram este en grupos/canales

2. Asegurate de que las credenciales en `.env` sean correctas┌─────────────────┐│

3. Verifica la sesion: elimina `*.session` y vuelve a autenticarte

4. Ejecuta manualmente: `python mcp_integration/list_dialogs.py`│  Flask Backend  │  ← Servidor Python├── backend/



### El monitor no encuentra posts│   Port 5000     ││   ├── app.py                   # API Flask (servidor backend)



**Sintoma:**└────────┬────────┘│   ├── posts.db                 # Base de datos SQLite

`/api/refresh` retorna 0 posts.

         ││   └── requirements.txt         # Dependencias específicas del backend

**Solucion:**

1. Verifica que el `TELEGRAM_GROUP_ID` en `.env` sea correcto (debe ser negativo)         ├─► SQLite Database (posts.db)│

2. Asegurate de que tu cuenta tenga acceso al grupo

3. Verifica que haya posts recientes en el grupo         │├── frontend/

4. Revisa los logs en la consola del backend

         └─► Telegram Monitor (telegram_mcp.py)│   └── index.html               # Dashboard visual (SPA)

### Las imagenes no se muestran

                    ││

**Sintoma:**

Posts sin imagenes o placeholder roto.                    ├─► Telegram API (telethon)└── mcp_integration/



**Solucion:**                    └─► Web Scraping (BeautifulSoup + Playwright)    ├── telegram_mcp.py          # Monitor principal de Telegram

1. El sistema usa 6 niveles de fallback, deberia mostrar siempre algo

2. Verifica la consola del navegador (F12) para errores```    └── monitor_state.json       # Estado del monitor (último mensaje procesado)

3. Comprueba que los servicios de fallback esten disponibles

4. Limpia cache del navegador: Ctrl+Shift+Delete```



### Errores de encoding---



**Sintoma:**## 🔄 Flujo de Funcionamiento

```

UnicodeDecodeError o caracteres extraños## Estructura del Proyecto

```

1. **Monitor de Telegram** (`telegram_mcp.py`):

**Solucion:**

Los scripts ya configuran UTF-8, pero si persiste:```   - Se conecta al grupo de Telegram usando `telethon`



Windows (PowerShell):telegram-ai-dashboard/   - Lee mensajes nuevos desde el último procesado

```powershell

$env:PYTHONIOENCODING = 'utf-8'├── START.bat              # Launcher Windows (doble click)   - Extrae URLs de los mensajes

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

```├── start.ps1              # Script de inicio (Windows)   - Procesa cada URL para extraer contenido



macOS/Linux:├── start.sh               # Script de inicio (macOS/Linux)

```bash

export PYTHONIOENCODING='utf-8'├── .env                   # Configuracion (no incluido en git)2. **Extracción de Contenido** (multi-estrategia):

export LANG=en_US.UTF-8

```├── .env.example           # Plantilla de configuracion   - **Intento 1**: Request HTTP normal con headers mejorados



### Error al instalar dependencias├── requirements.txt       # Dependencias principales   - **Intento 2**: Si detecta anti-bot (status 202/403), usa Playwright con navegador real



**Sintoma:**│   - Extrae: título, resumen, imagen, proveedor, tipo de contenido

```

ERROR: Could not install packages due to an OSError├── backend/   - Clasifica contenido: Noticia, Artículo, Blog, Red Social, Investigación, Video

```

│   ├── app.py               # Servidor Flask (API REST)

**Solucion:**

1. Actualiza pip: `python -m pip install --upgrade pip`│   ├── requirements.txt     # Dependencias del backend3. **Backend Flask** (`app.py`):

2. Usa virtual environment:

   ```bash│   └── posts.db            # Base de datos SQLite   - Recibe posts del monitor vía API REST

   python -m venv venv

   # Windows│   - Valida y detecta duplicados por URL

   .\venv\Scripts\activate

   # macOS/Linux├── frontend/   - Almacena en SQLite (`backend/posts.db`)

   source venv/bin/activate

   ```│   └── index.html          # Dashboard SPA   - Sirve API para el frontend

3. Instala dependencias de nuevo: `pip install -r requirements.txt`

│

### setup_env.ps1/sh no tiene permisos

├── mcp_integration/4. **Frontend** (`index.html`):

**Sintoma (macOS/Linux):**

```│   ├── telegram_mcp.py     # Monitor de Telegram   - Consulta API cada 30 segundos

Permission denied: ./setup_env.sh

```│   └── list_dialogs.py     # Utilidad para listar grupos   - Muestra posts en grid visual



**Solucion:**│   - Soporta imágenes reales o generadas (DiceBear)

```bash

chmod +x setup_env.sh└── docs/                    # Documentacion completa

chmod +x start.sh

./start.sh    ├── QUICKSTART.md## 🛠️ Tecnologías Utilizadas

```

    ├── SECURITY.md

**Sintoma (Windows):**

```    └── PRE-COMMIT-CHECKLIST.md### Backend

File cannot be loaded because running scripts is disabled

``````- **Flask 3.1.2** - Framework web



**Solucion:**- **Flask-CORS 6.0.1** - Cross-Origin Resource Sharing

```powershell

# Ejecutar PowerShell como administrador---- **SQLite** - Base de datos embebida

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

```



### El backend no se inicia## Endpoints de la API### Scraping & Parsing



**Sintoma:**- **Telethon 1.41.2** - Cliente de Telegram

```

ModuleNotFoundError: No module named 'flask'### `GET /api/posts`- **Requests 2.32.4** - HTTP client

```

Retorna todos los posts ordenados por fecha (mas recientes primero)- **BeautifulSoup4 4.13.5** - Parsing HTML

**Solucion:**

1. Verifica que las dependencias esten instaladas:- **lxml 6.0.2** - Parser XML/HTML de alto rendimiento

   ```bash

   pip install -r backend/requirements.txt**Response:**- **Playwright 1.55.0** - Browser automation para anti-bot

   ```

2. Si usas virtual environment, asegurate de activarlo```json

3. Verifica Python version: `python --version` (debe ser 3.8+)

[### Utilidades

### El dashboard no se abre automaticamente

  {- **python-dotenv 1.1.1** - Manejo de variables de entorno

**Sintoma:**

El backend inicia pero el navegador no se abre.    "id": 1,



**Solucion:**    "title": "Titulo del post",## 🎨 Estrategias de Extracción

1. Abre manualmente: [http://localhost:5000](http://localhost:5000)

2. Verifica que el puerto 5000 no este bloqueado por firewall    "summary": "Resumen del contenido",

3. Si usas WSL (Windows), accede desde Windows: `http://localhost:5000`

    "source_url": "https://ejemplo.com",### Títulos

## Seguridad

    "image_url": "https://imagen.com/img.jpg",1. Open Graph (`og:title`)

### Archivos Protegidos

    "release_date": "2025-10-04",2. Twitter Card (`twitter:title`)

Los siguientes archivos **NUNCA** deben subirse a GitHub:

    "provider": "ejemplo.com",3. Tag `<title>`

- `.env` - Contiene credenciales sensibles

- `*.session` - Sesiones de Telegram    "type": "Articulo",4. Primera etiqueta `<h1>`

- `*.db` - Base de datos con contenido privado

    "created_at": "2025-10-04 10:30:00"5. Fallback: nombre del dominio

Estos archivos estan incluidos en `.gitignore`.

  }

### Mejores Practicas

]### Resúmenes

1. **Nunca compartas tu `.env`** con nadie

2. **No subas screenshots** que muestren credenciales```1. Open Graph (`og:description`)

3. **Usa controles de acceso** en tu grupo de Telegram

4. **Rota credenciales periodicamente**2. Twitter Card (`twitter:description`)

5. **Revisa commits** antes de hacer push: consulta [PRE-COMMIT-CHECKLIST.md](docs/PRE-COMMIT-CHECKLIST.md)

### `POST /api/refresh`3. Meta description

### Verificacion Pre-Commit

Ejecuta el monitor de Telegram para buscar nuevos posts4. Primer párrafo de `<article>`, `<main>` o `<p>`

Antes de hacer commit, ejecuta:

5. Fallback: mensaje genérico

```bash

# Verificar que no haya archivos sensibles**Response:**

git status

```json### Imágenes

# Verificar contenido a commitear

git diff --cached{1. Open Graph (`og:image`)



# Si encuentras credenciales, usa:  "success": true,2. Twitter Card (`twitter:image`)

git reset HEAD <archivo>

```  "message": "Monitor ejecutado correctamente",3. `<link rel="image_src">`



## Roadmap  "total_posts": 154. Primera imagen `<img>` de tamaño sustancial



### Version Actual (v1.0)}5. Fallback: generación con DiceBear API



- [x] Monitoreo automatico de grupos de Telegram```

- [x] Dashboard web responsive

- [x] Sistema de filtros### Sitios Especiales

- [x] Actualizacion manual y automatica

- [x] Sistema de imagenes con fallback---- **X.com/Twitter**: Extractor específico para meta tags de Twitter

- [x] Configuracion interactiva

- [x] Scripts de inicio automatico- **Sitios protegidos**: Detección automática y uso de Playwright

- [x] Soporte multi-plataforma

## Caracteristicas del Dashboard

### Proximas Funcionalidades (v1.1)

## 🔒 Seguridad

- [ ] Busqueda de texto completo en posts

- [ ] Exportar posts a CSV/JSON### Auto-refresh Inteligente

- [ ] Graficos de estadisticas

- [ ] Notificaciones push para nuevos posts- Cada 5 minutos busca automaticamente nuevos posts en Telegram### Archivos Protegidos por `.gitignore`

- [ ] Soporte para multiples grupos simultaneos

- [ ] Panel de administracion- Boton "Actualizar" para busqueda manual instantanea



### Futuro (v2.0)- Estadisticas en tiempo real (total posts, posts de hoy, ultima actualizacion)El proyecto incluye protección completa de información sensible:



- [ ] Integracion con Claude AI para resumen automatico

- [ ] Analisis de sentimiento

- [ ] Deteccion de tendencias### Filtros Dinamicos- 🔴 **`.env`** - Credenciales de Telegram API y API keys (CRÍTICO)

- [ ] API REST completa con autenticacion

- [ ] Dashboard multi-usuario- Filtros generados automaticamente segun los tipos de contenido- 🔴 **`*.session`** - Sesiones autenticadas de Telegram (CRÍTICO)

- [ ] Despliegue en cloud (Docker/Kubernetes)

- Top 5 categorias mas representadas + filtro "Otros"- 🟠 **`*.db`** - Bases de datos con posts y metadatos

## Licencia

- Contador de posts por cada categoria- 🟡 **`monitor_state.json`** - Estado del monitor (IDs de mensajes)

Este proyecto es de codigo abierto y esta disponible bajo la licencia MIT.

- Iconos personalizados por tipo- ⚪ **`__pycache__/`** - Cache de Python

## Contribuir



Las contribuciones son bienvenidas! Por favor:

### Sistema de Imagenes### ⚠️ NUNCA Subir a Git

1. Haz fork del repositorio

2. Crea una rama para tu feature: `git checkout -b feature/nueva-funcionalidad`Fallback inteligente con multiples fuentes:

3. Commit tus cambios: `git commit -m 'feat: Agregar nueva funcionalidad'`

4. Push a la rama: `git push origin feature/nueva-funcionalidad`1. Imagen real extraida del sitio web**Archivos críticos que NUNCA deben estar en el repositorio:**

5. Abre un Pull Request

2. Picsum Photos (fotos reales con seed)- ❌ Tu archivo `.env` con credenciales reales

Antes de enviar un PR:

- Asegurate de que el codigo funcione correctamente3. Vercel Avatar (avatares estilizados)- ❌ Archivos de sesión de Telegram (`*.session`)

- Verifica que no incluyas archivos sensibles (.env, *.session, *.db)

- Documenta nuevas funcionalidades en el README4. UI Avatars (iniciales + colores personalizados)- ❌ Tokens o API keys



## Autor5. Boring Avatars (disenos geometricos)- ❌ Base de datos con contenido real (`*.db`)



**Jose Tapia**6. SVG con gradiente (ultimo recurso garantizado)

- GitHub: [@JoseTapiaUex](https://github.com/JoseTapiaUex)

- Proyecto: [telegram-ai-dashboard](https://github.com/JoseTapiaUex/telegram-ai-dashboard)**Usa `.env.example` como plantilla** (este SÍ puede ir en git)



## Agradecimientos### Responsive Design



- [Telethon](https://github.com/LonamiWebs/Telethon) - Cliente de Telegram API- **Movil** (< 768px): 1 columna### 📖 Guía Completa de Seguridad

- [Flask](https://flask.palletsprojects.com/) - Framework web

- [Playwright](https://playwright.dev/) - Automatizacion de navegador- **Tablet** (768-1279px): 2 columnas

- Todos los servicios de imagenes de fallback (Picsum, Vercel, UI Avatars, Boring Avatars)

- **Desktop** (>= 1280px): 3 columnasPara información detallada sobre:

---

- Header con imagen de fondo espacial- Qué hacer si expusiste credenciales por error

**Nota:** Este proyecto es para fines educativos y de investigacion. Asegurate de cumplir con los terminos de servicio de Telegram al usar su API.

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
