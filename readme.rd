TELEGRAM AI DASHBOARD

Sistema automatizado de monitoreo de grupos de Telegram con dashboard web interactivo. Extrae contenido de URLs compartidas en grupos de Telegram, procesa la informacion con scraping inteligente (incluyendo sitios protegidos con Playwright), y presenta los resultados en un dashboard visual profesional y responsive.

CARACTERISTICAS PRINCIPALES

- Monitorizacion automatica de grupos de Telegram cada 5 minutos
- Extraccion inteligente de contenido web con fallback a Playwright para sitios protegidos
- Sistema de imagenes con multiples estrategias de fallback
- Dashboard web profesional y completamente responsive (movil, tablet, desktop)
- Filtros dinamicos por tipo de contenido
- Deteccion automatica de duplicados
- Sistema de configuracion interactiva para primer uso
- Scripts de inicio automatico para Windows, macOS y Linux
- Actualizacion manual y automatica desde el dashboard

TABLA DE CONTENIDOS

- Inicio Rapido
- Requisitos
- Instalacion
- Configuracion
- Uso
- Arquitectura
- API
- Troubleshooting
- Documentacion Adicional
- Roadmap
- Licencia

INICIO RAPIDO

Windows:
  git clone https://github.com/JoseTapiaUex/telegram-ai-dashboard.git
  cd telegram-ai-dashboard
  START.bat

macOS / Linux:
  git clone https://github.com/JoseTapiaUex/telegram-ai-dashboard.git
  cd telegram-ai-dashboard
  chmod +x start.sh
  ./start.sh

El sistema detectara si es la primera ejecucion y lanzara un asistente interactivo para configurar las credenciales de Telegram.

REQUISITOS

Requisitos del Sistema:
- Python 3.8 o superior
- pip (gestor de paquetes de Python)
- Git
- Navegador web moderno (Chrome, Firefox, Edge, Safari)
- Conexion a Internet

Credenciales de Telegram:
Para usar este sistema necesitas obtener credenciales de la API de Telegram:
1. Visita https://my.telegram.org/auth
2. Inicia sesion con tu numero de telefono
3. Ve a "API development tools"
4. Crea una nueva aplicacion (si no tienes una)
5. Obtendras: api_id (numero) y api_hash (cadena alfanumerica)

INSTALACION

Paso 1: Clonar el Repositorio
  git clone https://github.com/JoseTapiaUex/telegram-ai-dashboard.git
  cd telegram-ai-dashboard

Paso 2: Ejecutar el Script de Inicio
El sistema incluye scripts de inicio automatico que:
- Instalan todas las dependencias
- Configuran el entorno
- Lanzan el asistente de configuracion (primera vez)
- Inician el backend
- Abren el dashboard en el navegador

Windows:
  START.bat
  
O usando PowerShell:
  .\start.ps1

macOS / Linux:
  chmod +x start.sh
  ./start.sh

Instalacion Manual (Opcional):
  pip install -r requirements.txt
  python -m playwright install chromium
  cp .env.example .env
  # Editar .env con tus credenciales
  python backend/app.py
  # Visita http://localhost:5000

CONFIGURACION

Sistema de Configuracion Interactiva:
La primera vez que ejecutes el sistema, se lanzara automaticamente un asistente interactivo.

Paso 1: Credenciales de Telegram API
El asistente te pedira:
- TG_APP_ID: Tu API ID de Telegram (numero)
- TG_API_HASH: Tu API Hash de Telegram
- TG_PHONE: Tu numero de telefono (formato: +34...)

Paso 2: Seleccion de Grupo
El sistema mostrara una tabla con TODOS tus chats de Telegram:
  ID              Tipo        Nombre
  -4945424696     Grupo       test-ia-agents
  -1001234567     Supergrupo  Mi Proyecto

Luego te pedira:
- TELEGRAM_GROUP_ID: El ID del grupo que quieres monitorear

Paso 3: Anthropic API (Opcional)
Pregunta si quieres usar Anthropic Claude API (actualmente no requerido)

El asistente:
- Valida todos los datos en tiempo real
- Crea automaticamente el archivo .env
- Hace backup si ya existe un .env previo
- Muestra un resumen de la configuracion

Configuracion Manual del .env:
  cp .env.example .env

Editar .env con tus valores:
  TG_APP_ID=12345678
  TG_API_HASH=abcdef1234567890
  TG_PHONE=+34123456789
  TELEGRAM_GROUP_ID=-4945424696
  USE_ANTHROPIC=false
  ANTHROPIC_API_KEY=

Listar tus Grupos de Telegram:
  python mcp_integration/list_dialogs.py

USO

Iniciar el Sistema:

Windows:
  START.bat

macOS/Linux:
  ./start.sh

Esto iniciara:
1. Backend Flask en http://localhost:5000
2. Dashboard web (se abre automaticamente)
3. Sistema de monitorizacion

Usar el Dashboard:

Vista Principal:
- Grid de posts con imagenes, titulos y resumenes
- Diseño responsive (1 columna movil, 2 tablet, 3 desktop)
- Enlaces a fuentes originales

Barra de Estadisticas:
- Total de posts
- Posts publicados hoy
- Ultima actualizacion

Filtros Dinamicos:
- Boton "Todos"
- Filtros por tipo (Noticia, Articulo, Blog, etc.)
- Top 5 categorias
- Categoria "Otros" agrupa el resto

Boton de Actualizacion Manual:
- Click para buscar nuevos posts inmediatamente
- Estados: Normal, Cargando, Exito, Error
- Auto-refresh cada 5 minutos

Sistema de Actualizacion:

Automatica (cada 5 minutos):
- Monitoriza el grupo
- Extrae URLs
- Procesa contenido
- Detecta duplicados
- Actualiza dashboard

Manual:
- Click en "Actualizar"
- Busqueda inmediata
- Feedback visual

Acceder al Dashboard:

Mismo ordenador:
  http://localhost:5000

Otros dispositivos (misma red):
  http://TU_IP_LOCAL:5000

Obtener IP local:
  Windows: ipconfig | Select-String "IPv4"
  macOS/Linux: ifconfig | grep "inet "

Detener el Sistema:
- Windows: Cierra ventana PowerShell o Ctrl+C
- macOS/Linux: Ctrl+C en terminal

ARQUITECTURA

Componentes Principales:

1. Monitor de Telegram (mcp_integration/telegram_mcp.py)
   - Conecta a Telegram via Telethon
   - Lee mensajes del grupo configurado
   - Extrae URLs de los mensajes
   - Procesa cada URL

2. Scraper Web
   - BeautifulSoup + requests (primera capa)
   - Playwright (fallback para sitios protegidos)
   - Estrategias multiples de extraccion

3. Backend API (backend/app.py)
   - Flask REST API
   - Base de datos SQLite
   - Endpoints para CRUD de posts
   - Endpoint de refresh que ejecuta monitor

4. Frontend (frontend/index.html)
   - Dashboard responsive
   - Vanilla JavaScript
   - Sin dependencias externas
   - Actualiza datos via fetch API

5. Base de Datos (backend/posts.db)
   - SQLite
   - Tabla posts con campos:
     * id, title, summary, source_url
     * image_url, release_date, provider, type

Flujo de Datos:

Telegram Grupo
  ↓
Monitor (telegram_mcp.py)
  ↓ extrae URLs
Web Scraper (BeautifulSoup/Playwright)
  ↓ extrae: title, summary, image, metadata
Backend API (Flask)
  ↓ guarda en SQLite
  ↓ detecta duplicados
Frontend Dashboard
  ↓ muestra posts
Usuario

Estrategias de Extraccion:

Contenido HTML:
1. Intento con requests + BeautifulSoup
2. Si falla (status 202/403 o contenido vacio):
   - Usar Playwright con navegador real
3. Extraer: Open Graph, Twitter Cards, meta tags
4. Fallback: primer h1, parrafos, etc.

Imagenes (5 niveles de fallback):
1. Imagen real del scraping (Open Graph, Twitter Card, etc.)
2. Picsum Photos (fotos reales con seed)
3. Vercel Avatar (avatares estilizados)
4. UI Avatars (iniciales con colores)
5. Boring Avatars (disenos geometricos)
6. SVG con gradiente (ultimo recurso)

Tipos de Contenido:
Detecta automaticamente por dominio y meta tags:
- Noticia (BBC, CNN, Marca, etc.)
- Articulo de Blog (Medium, blogs)
- Video (YouTube, Vimeo)
- Investigacion (GitHub, arXiv)
- Red Social (X.com, Twitter)
- Articulo (general)

API

Base URL: http://localhost:5000

Endpoints:

GET /
  Descripcion: Sirve el frontend (index.html)
  Respuesta: HTML

GET /api/posts
  Descripcion: Obtiene todos los posts
  Respuesta: Array de objetos post
  Ejemplo:
    [
      {
        "id": 1,
        "title": "Titulo del post",
        "summary": "Resumen de 2-3 lineas",
        "source_url": "https://ejemplo.com/articulo",
        "image_url": "https://ejemplo.com/imagen.jpg",
        "release_date": "2025-10-04",
        "provider": "Ejemplo.com",
        "type": "Noticia"
      }
    ]

POST /api/posts
  Descripcion: Crea un nuevo post
  Body (JSON):
    {
      "title": "string",
      "summary": "string",
      "source_url": "string",
      "image_url": "string",
      "release_date": "YYYY-MM-DD",
      "provider": "string",
      "type": "string"
    }
  Respuesta:
    - 201: Post creado
    - 409: Duplicate (si source_url ya existe)

POST /api/refresh
  Descripcion: Ejecuta monitor de Telegram para buscar nuevos posts
  Respuesta:
    {
      "success": true,
      "total_posts": 15
    }
  Timeout: 120 segundos

TROUBLESHOOTING

Problema: Python no encontrado
Solucion:
  - Instalar Python 3.8+ desde python.org
  - Verificar: python --version
  - Windows: Agregar Python al PATH

Problema: Puerto 5000 en uso
Solucion:
  Windows: Get-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess | Stop-Process
  macOS/Linux: lsof -ti:5000 | xargs kill

Problema: Playwright no funciona
Solucion:
  python -m playwright install chromium
  python -m playwright install-deps

Problema: No se listan grupos de Telegram
Solucion:
  - Verificar credenciales en .env
  - Verificar formato telefono (+34...)
  - Borrar archivo .session y reintentar
  - Verificar que list_dialogs.py funciona:
    python mcp_integration/list_dialogs.py

Problema: Monitor no encuentra posts nuevos
Solucion:
  - Verificar TELEGRAM_GROUP_ID correcto (numero negativo)
  - Verificar que hay mensajes con URLs en el grupo
  - Borrar monitor_state.json para reprocesar todo
  - Ejecutar manualmente:
    python mcp_integration/telegram_mcp.py

Problema: Imagenes no se muestran
Solucion:
  - Sistema tiene 5 niveles de fallback
  - Si todas fallan, verifica conexion a Internet
  - Abrir consola del navegador (F12) para ver errores

Problema: Error de encoding (UTF-8)
Solucion:
  Windows PowerShell:
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Problema: Dependencias no se instalan
Solucion:
  pip install --upgrade pip
  pip install -r requirements.txt --force-reinstall

Problema: "Permission denied" al ejecutar scripts
Solucion:
  Windows:
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  macOS/Linux:
    chmod +x start.sh setup_env.sh

Problema: Backend no inicia
Solucion:
  - Verificar puerto 5000 libre
  - Verificar .env existe y tiene valores
  - Ejecutar manualmente:
    python backend/app.py
  - Ver errores en consola

Problema: Dashboard no abre automaticamente
Solucion:
  - Abrir manualmente: http://localhost:5000
  - Verificar que backend este corriendo
  - Verificar firewall no bloquea puerto 5000

DOCUMENTACION ADICIONAL

Documentacion completa en carpeta docs/:
- docs/QUICKSTART.md: Guia rapida de inicio
- docs/SECURITY.md: Guia de seguridad y buenas practicas
- docs/PRE-COMMIT-CHECKLIST.md: Lista de verificacion antes de commit

Archivos importantes:
- .env.example: Plantilla de configuracion
- .gitignore: Proteccion de archivos sensibles
- requirements.txt: Dependencias de Python

ESTRUCTURA DEL PROYECTO

telegram-ai-dashboard/
├── backend/
│   ├── app.py                    (API Flask)
│   ├── posts.db                  (Base de datos SQLite)
│   └── requirements.txt          (Dependencias backend)
├── frontend/
│   └── index.html                (Dashboard web)
├── mcp_integration/
│   ├── telegram_mcp.py           (Monitor principal)
│   ├── list_dialogs.py           (Herramienta: listar grupos)
│   └── monitor_state.json        (Estado del monitor)
├── docs/
│   ├── QUICKSTART.md
│   ├── SECURITY.md
│   └── PRE-COMMIT-CHECKLIST.md
├── start.ps1                     (Script inicio Windows)
├── setup_env.ps1                 (Configuracion Windows)
├── start.sh                      (Script inicio macOS/Linux)
├── setup_env.sh                  (Configuracion macOS/Linux)
├── START.bat                     (Launcher Windows)
├── requirements.txt              (Dependencias principales)
├── .env.example                  (Plantilla configuracion)
├── .gitignore                    (Proteccion archivos sensibles)
└── README.md                     (Este archivo)

ROADMAP

Funcionalidades planificadas:

v1.1:
- Busqueda de posts por texto
- Filtros por rango de fechas
- Filtros por proveedor/fuente
- Exportar posts a CSV/JSON

v1.2:
- Paginacion o scroll infinito
- Modo oscuro manual (toggle)
- Soporte para multiples grupos simultaneos
- Notificaciones push para nuevos posts

v1.3:
- Categorias personalizadas por usuario
- Sistema de etiquetas/tags
- Guardar posts favoritos
- Compartir posts en redes sociales

v2.0:
- API de IA para resumenes personalizados
- Analisis de sentimiento de contenido
- Graficos y estadisticas avanzadas
- Sistema de usuarios y autenticacion

CONTRIBUCIONES

Las contribuciones son bienvenidas. Por favor:
1. Fork del repositorio
2. Crear branch para tu feature
3. Commit de tus cambios
4. Push al branch
5. Abrir Pull Request

LICENCIA

MIT License - Ver archivo LICENSE para detalles

CONTACTO

GitHub: https://github.com/JoseTapiaUex/telegram-ai-dashboard