# ============================================================================
# Setup Environment - Configuracion Interactiva de .env
# ============================================================================
# Este script guia al usuario paso a paso para crear su archivo .env
# con todas las credenciales necesarias para el sistema.
# ============================================================================

# Configurar salida UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Funcion para mostrar encabezados
function Show-Header {
    param([string]$Title)
    Write-Host "`n" -NoNewline
    Write-Host "=" * 80 -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "=" * 80 -ForegroundColor Cyan
    Write-Host ""
}

# Funcion para validar que un valor no este vacio
function Test-NotEmpty {
    param([string]$Value, [string]$FieldName)
    
    if ([string]::IsNullOrWhiteSpace($Value)) {
        Write-Host "ERROR: $FieldName no puede estar vacio" -ForegroundColor Red
        return $false
    }
    return $true
}

# Funcion para validar numero
function Test-IsNumber {
    param([string]$Value, [string]$FieldName)
    
    if (-not ($Value -match '^\d+$')) {
        Write-Host "ERROR: $FieldName debe ser un numero" -ForegroundColor Red
        return $false
    }
    return $true
}

# Funcion para validar formato de telefono
function Test-PhoneFormat {
    param([string]$Value)
    
    if (-not ($Value -match '^\+\d{10,15}$')) {
        Write-Host "ERROR: Telefono debe tener formato +XX... (ej: +34612345678)" -ForegroundColor Red
        return $false
    }
    return $true
}

# Funcion para validar ID de grupo (negativo)
function Test-GroupIdFormat {
    param([string]$Value)
    
    if (-not ($Value -match '^-\d+$')) {
        Write-Host "ERROR: TELEGRAM_GROUP_ID debe ser un numero negativo" -ForegroundColor Red
        Write-Host "   Los IDs de grupos de Telegram siempre son negativos (ej: -4945424696)" -ForegroundColor Yellow
        return $false
    }
    return $true
}

# Verificar si .env ya existe
if (Test-Path ".env") {
    Write-Host "Ya existe un archivo .env" -ForegroundColor Yellow
    $overwrite = Read-Host "Deseas reconfigurarlo? (S/N) [N]"
    
    if ($overwrite -ne "S" -and $overwrite -ne "s") {
        Write-Host "Manteniendo configuracion existente" -ForegroundColor Green
        exit 0
    }
    
    # Hacer backup del .env existente
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item ".env" ".env.backup_$timestamp"
    Write-Host "Backup creado: .env.backup_$timestamp" -ForegroundColor Cyan
}

# ============================================================================
# BIENVENIDA
# ============================================================================
Clear-Host
Show-Header "CONFIGURACION INICIAL - Telegram AI Dashboard"

Write-Host "Este asistente te guiara para configurar tu archivo .env" -ForegroundColor White
Write-Host ""
Write-Host "Necesitaras:" -ForegroundColor Yellow
Write-Host "  1. Credenciales de Telegram API (https://my.telegram.org/auth)" -ForegroundColor White
Write-Host "  2. Tu numero de telefono de Telegram" -ForegroundColor White
Write-Host "  3. ID del grupo que quieres monitorear" -ForegroundColor White
Write-Host ""
Write-Host "Presiona ENTER para continuar..." -ForegroundColor Cyan
Read-Host

# ============================================================================
# PASO 1: CREDENCIALES DE TELEGRAM API
# ============================================================================
Show-Header "PASO 1/4: Credenciales de Telegram API"

Write-Host "Para obtener tus credenciales:" -ForegroundColor Yellow
Write-Host "  1. Ve a: https://my.telegram.org/auth" -ForegroundColor White
Write-Host "  2. Inicia sesion con tu numero de telefono" -ForegroundColor White
Write-Host "  3. Ve a 'API Development Tools'" -ForegroundColor White
Write-Host "  4. Crea una nueva aplicacion (si no tienes una)" -ForegroundColor White
Write-Host "  5. Copia api_id y api_hash" -ForegroundColor White
Write-Host ""

# Pedir TG_APP_ID
do {
    $TG_APP_ID = Read-Host "Ingresa tu TG_APP_ID (api_id)"
    $valid = (Test-NotEmpty $TG_APP_ID "TG_APP_ID") -and (Test-IsNumber $TG_APP_ID "TG_APP_ID")
} while (-not $valid)

# Pedir TG_API_HASH
do {
    $TG_API_HASH = Read-Host "Ingresa tu TG_API_HASH (api_hash)"
    $valid = Test-NotEmpty $TG_API_HASH "TG_API_HASH"
} while (-not $valid)

# Pedir TG_PHONE
do {
    Write-Host ""
    Write-Host "Formato del telefono: +[codigo pais][numero]" -ForegroundColor Yellow
    Write-Host "Ejemplos: +34612345678 (Espana), +1234567890 (EE.UU.)" -ForegroundColor Gray
    $TG_PHONE = Read-Host "Ingresa tu numero de telefono"
    $valid = (Test-NotEmpty $TG_PHONE "TG_PHONE") -and (Test-PhoneFormat $TG_PHONE)
} while (-not $valid)

Write-Host ""
Write-Host "Credenciales de Telegram API configuradas" -ForegroundColor Green

# ============================================================================
# PASO 2: CREAR .env TEMPORAL Y EJECUTAR list_dialogs.py
# ============================================================================
Show-Header "PASO 2/4: Identificar el Grupo a Monitorear"

Write-Host "Creando archivo .env temporal..." -ForegroundColor Cyan

# Crear .env temporal con las credenciales basicas
@"
# Telegram API Credentials
TG_APP_ID=$TG_APP_ID
TG_API_HASH=$TG_API_HASH
TG_PHONE=$TG_PHONE

# Telegram Group to Monitor
TELEGRAM_GROUP_ID=

# Anthropic API (Optional - Currently not in use)
USE_ANTHROPIC=false
ANTHROPIC_API_KEY=
"@ | Out-File -FilePath ".env" -Encoding UTF8 -NoNewline

Write-Host "Archivo .env temporal creado" -ForegroundColor Green
Write-Host ""
Write-Host "Conectando a Telegram para listar tus grupos..." -ForegroundColor Cyan
Write-Host "Si es tu primera vez, Telegram te pedira un codigo de verificacion" -ForegroundColor Yellow
Write-Host ""
Write-Host "Presiona ENTER para continuar..." -ForegroundColor Cyan
Read-Host

# Ejecutar list_dialogs.py
Write-Host ""
Write-Host "=" * 80 -ForegroundColor Cyan
try {
    $env:PYTHONIOENCODING = 'utf-8'
    python mcp_integration/list_dialogs.py
    $listDialogsSuccess = $true
} catch {
    Write-Host "ERROR al listar dialogos: $_" -ForegroundColor Red
    $listDialogsSuccess = $false
}
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host ""

if (-not $listDialogsSuccess) {
    Write-Host "No se pudieron listar los grupos automaticamente" -ForegroundColor Yellow
    Write-Host "   Puedes ejecutar manualmente: python mcp_integration/list_dialogs.py" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# PASO 3: PEDIR TELEGRAM_GROUP_ID
# ============================================================================
Show-Header "PASO 3/4: Seleccionar Grupo"

Write-Host "De la tabla anterior, copia el ID del grupo que quieres monitorear." -ForegroundColor Yellow
Write-Host "Recuerda: Los IDs de grupos siempre son NEGATIVOS (ej: -4945424696)" -ForegroundColor Gray
Write-Host ""

# Pedir TELEGRAM_GROUP_ID
do {
    $TELEGRAM_GROUP_ID = Read-Host "Ingresa el TELEGRAM_GROUP_ID"
    $valid = (Test-NotEmpty $TELEGRAM_GROUP_ID "TELEGRAM_GROUP_ID") -and (Test-GroupIdFormat $TELEGRAM_GROUP_ID)
} while (-not $valid)

Write-Host ""
Write-Host "Grupo seleccionado: $TELEGRAM_GROUP_ID" -ForegroundColor Green

# ============================================================================
# PASO 4: ANTHROPIC API (OPCIONAL)
# ============================================================================
Show-Header "PASO 4/4: Anthropic API (Opcional)"

Write-Host "El sistema puede usar Claude AI de Anthropic para mejorar los resumenes." -ForegroundColor White
Write-Host "Actualmente esta funcion esta DESHABILITADA por defecto" -ForegroundColor Yellow
Write-Host ""

$useAnthropic = Read-Host "Deseas habilitar Anthropic API? (S/N) [N]"

if ($useAnthropic -eq "S" -or $useAnthropic -eq "s") {
    Write-Host ""
    Write-Host "Obten tu API Key en: https://console.anthropic.com/settings/keys" -ForegroundColor Gray
    $ANTHROPIC_API_KEY = Read-Host "Ingresa tu ANTHROPIC_API_KEY"
    
    if (Test-NotEmpty $ANTHROPIC_API_KEY "ANTHROPIC_API_KEY") {
        $USE_ANTHROPIC = "true"
        Write-Host "Anthropic API habilitada" -ForegroundColor Green
    } else {
        $USE_ANTHROPIC = "false"
        $ANTHROPIC_API_KEY = ""
        Write-Host "API Key vacia, Anthropic quedara deshabilitado" -ForegroundColor Yellow
    }
} else {
    $USE_ANTHROPIC = "false"
    $ANTHROPIC_API_KEY = ""
    Write-Host "Anthropic API deshabilitada (configuracion por defecto)" -ForegroundColor Green
}

# ============================================================================
# CREAR .env FINAL
# ============================================================================
Show-Header "Guardando Configuracion"

$envContent = @"
# Telegram API Credentials
# Get your credentials from https://my.telegram.org
# 1. Go to https://my.telegram.org
# 2. Log in with your phone number
# 3. Go to "API Development Tools"
# 4. Create a new application
# 5. Copy api_id and api_hash

TG_APP_ID=$TG_APP_ID
TG_API_HASH=$TG_API_HASH
TG_PHONE=$TG_PHONE

# Telegram Group to Monitor
# Use the list_dialogs.py script to find your group ID:
# python mcp_integration/list_dialogs.py
TELEGRAM_GROUP_ID=$TELEGRAM_GROUP_ID

# Anthropic API (Optional - Currently not in use)
# If you want to use Claude AI for enhanced content processing
# Get your key from https://console.anthropic.com/settings/keys
USE_ANTHROPIC=$USE_ANTHROPIC
ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY
"@

$envContent | Out-File -FilePath ".env" -Encoding UTF8 -NoNewline

Write-Host "Archivo .env creado exitosamente" -ForegroundColor Green

# ============================================================================
# RESUMEN FINAL
# ============================================================================
Show-Header "RESUMEN DE CONFIGURACION"

Write-Host "TG_APP_ID:         " -NoNewline -ForegroundColor Gray
Write-Host $TG_APP_ID -ForegroundColor White

Write-Host "TG_API_HASH:       " -NoNewline -ForegroundColor Gray
Write-Host ($TG_API_HASH.Substring(0, [Math]::Min(10, $TG_API_HASH.Length)) + "...") -ForegroundColor White

Write-Host "TG_PHONE:          " -NoNewline -ForegroundColor Gray
Write-Host $TG_PHONE -ForegroundColor White

Write-Host "TELEGRAM_GROUP_ID: " -NoNewline -ForegroundColor Gray
Write-Host $TELEGRAM_GROUP_ID -ForegroundColor White

Write-Host "USE_ANTHROPIC:     " -NoNewline -ForegroundColor Gray
if ($USE_ANTHROPIC -eq "true") {
    Write-Host "Habilitado" -ForegroundColor Green
} else {
    Write-Host "Deshabilitado" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuracion completada exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "  1. El sistema continuara con la instalacion automatica" -ForegroundColor White
Write-Host "  2. Se iniciara el backend Flask" -ForegroundColor White
Write-Host "  3. Se abrira el dashboard en tu navegador" -ForegroundColor White
Write-Host ""
Write-Host "NOTA: Tu archivo .env esta protegido por .gitignore" -ForegroundColor Cyan
Write-Host "   No se subira a GitHub (tus credenciales estan seguras)" -ForegroundColor Cyan
Write-Host ""
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host ""
