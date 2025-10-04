# Telegram AI Dashboard - Script de Inicio CompletoWrite-Host "🔍 [1/7] Verificando Python..." -ForegroundColor Yellow# Configura elWrite-Host "📦 [2/7] Verificando dependencias..." -ForegroundColor Yellowentorno, instala dependencias, inicia backend y abre el frontend
# Compatible con Windows (PowerShell)

# Configuración de encoding para evitar problemas con emojis
$env:PYTHONIOENCODING = 'utf-8'
$ErrorActionPreference = "Continue"

# Banner
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "   🤖 Telegram AI Dashboard - Startup Script   " -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Cambiar al directorio raíz del proyecto
Set-Location $PSScriptRoot

# ============================================
# 0. VERIFICAR CONFIGURACION (.env)
# ============================================
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'isFirstRun')]
$isFirstRun = $false
if (-not (Test-Path ".env")) {
    Write-Host "⚙️  [0/7] Configuracion inicial requerida..." -ForegroundColor Yellow
    Write-Host "   No se encontro archivo .env" -ForegroundColor Yellow
    Write-Host ""
    
    # Ejecutar setup_env.ps1
    if (Test-Path "setup_env.ps1") {
        & .\setup_env.ps1
        
        # Verificar si se creo el .env
        if (-not (Test-Path ".env")) {
            Write-Host "   ❌ No se pudo crear el archivo .env" -ForegroundColor Red
            Write-Host "   Ejecuta manualmente: .\setup_env.ps1" -ForegroundColor Yellow
            Read-Host "Presiona Enter para salir"
            exit 1
        }
        $isFirstRun = $true
        Write-Host ""
    } else {
        Write-Host "   ❌ setup_env.ps1 no encontrado" -ForegroundColor Red
        Write-Host "   Crea manualmente un archivo .env con las credenciales" -ForegroundColor Yellow
        Read-Host "Presiona Enter para salir"
        exit 1
    }
}

# ============================================
# 1. VERIFICAR PYTHON
# ============================================
Write-Host "🔍 [1/5] Verificando Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "   ✅ Python encontrado: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Python no está instalado o no está en PATH" -ForegroundColor Red
    Write-Host "   📥 Descarga Python desde: https://www.python.org/downloads/" -ForegroundColor Yellow
    Read-Host "Presiona Enter para salir"
    exit 1
}
Write-Host ""

# ============================================
# 2. INSTALAR DEPENDENCIAS
# ============================================
Write-Host "📦 [2/5] Verificando dependencias..." -ForegroundColor Yellow

# Verificar requirements.txt raíz
if (Test-Path "requirements.txt") {
    Write-Host "   📄 Instalando dependencias principales..." -ForegroundColor Cyan
    pip install -q -r requirements.txt
    Write-Host "   ✅ Dependencias principales instaladas" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  requirements.txt no encontrado" -ForegroundColor Yellow
}

# Verificar requirements.txt del backend
if (Test-Path "backend/requirements.txt") {
    Write-Host "   📄 Instalando dependencias del backend..." -ForegroundColor Cyan
    pip install -q -r backend/requirements.txt
    Write-Host "   ✅ Dependencias del backend instaladas" -ForegroundColor Green
}

# Instalar Playwright browsers si es necesario
Write-Host "   🌐 Verificando Playwright..." -ForegroundColor Cyan
try {
    python -c "from playwright.sync_api import sync_playwright" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Playwright ya configurado" -ForegroundColor Green
    }
} catch {
    Write-Host "   📥 Instalando navegadores de Playwright..." -ForegroundColor Cyan
    playwright install chromium
    Write-Host "   ✅ Playwright configurado" -ForegroundColor Green
}
Write-Host ""

# ============================================
# 3. VERIFICAR CONFIGURACIÓN
# ============================================
Write-Host "⚙️  [3/7] Verificando configuración..." -ForegroundColor Yellow

if (-not (Test-Path ".env")) {
    Write-Host "   ⚠️  Archivo .env no encontrado" -ForegroundColor Red
    Write-Host "   📝 Copia .env.example a .env y configura tus credenciales" -ForegroundColor Yellow
    
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "   ✅ Archivo .env creado desde .env.example" -ForegroundColor Green
        Write-Host "   🔧 IMPORTANTE: Edita .env con tus credenciales de Telegram" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Presiona Enter cuando hayas configurado .env"
    } else {
        Write-Host "   ❌ No se puede continuar sin configuración" -ForegroundColor Red
        Read-Host "Presiona Enter para salir"
        exit 1
    }
} else {
    Write-Host "   ✅ Archivo .env encontrado" -ForegroundColor Green
}
Write-Host ""

# ============================================
# 4. INICIAR BACKEND
# ============================================
Write-Host "🚀 [4/7] Iniciando Backend Flask..." -ForegroundColor Yellow

# Verificar si el backend ya está corriendo
$backendRunning = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue

if ($backendRunning) {
    Write-Host "   ⚠️  Puerto 5000 ya en uso. Deteniendo proceso anterior..." -ForegroundColor Yellow
    taskkill /F /IM python.exe /FI "WINDOWTITLE eq Flask*" 2>$null
    Start-Sleep -Seconds 2
}

# Iniciar backend en nueva ventana
$backendPath = Join-Path $PSScriptRoot "backend"
$backendCommand = @"
cd '$backendPath'
`$env:PYTHONIOENCODING='utf-8'
Write-Host ''
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Green
Write-Host '   Flask Backend Server   ' -ForegroundColor Green
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Green
Write-Host ''
Write-Host '🌐 Servidor: http://localhost:5000' -ForegroundColor Cyan
Write-Host '🔄 Auto-refresh: Cada 5 minutos' -ForegroundColor Cyan
Write-Host '⚠️  No cierres esta ventana' -ForegroundColor Yellow
Write-Host ''
python app.py
"@

Start-Process pwsh -ArgumentList "-NoExit", "-Command", $backendCommand

# Esperar a que el backend inicie
Write-Host "   ⏳ Esperando que el backend inicie..." -ForegroundColor Cyan
$timeout = 15
$elapsed = 0
while ($elapsed -lt $timeout) {
    Start-Sleep -Seconds 1
    $elapsed++
    $check = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue
    if ($check) {
        Write-Host "   ✅ Backend iniciado en http://localhost:5000" -ForegroundColor Green
        break
    }
    if ($elapsed -eq $timeout) {
        Write-Host "   ❌ Timeout esperando el backend" -ForegroundColor Red
        Read-Host "Presiona Enter para salir"
        exit 1
    }
}
Write-Host ""

# ============================================
# 6. CARGAR POSTS INICIALES (Primera ejecución - DESPUÉS de iniciar backend)
# ============================================
if ($isFirstRun) {
    Write-Host "📥 [6/7] Cargando posts iniciales desde Telegram..." -ForegroundColor Yellow
    Write-Host "   Esta es tu primera ejecución, vamos a buscar posts en tu grupo" -ForegroundColor Cyan
    Write-Host "   Esperando 2 segundos para que el backend se estabilice..." -ForegroundColor Gray
    Start-Sleep -Seconds 2
    Write-Host ""
    
    try {
        $env:PYTHONIOENCODING = 'utf-8'
        python mcp_integration/telegram_mcp.py
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "   ✅ Posts iniciales cargados exitosamente" -ForegroundColor Green
            Write-Host "   Recarga el dashboard (F5) para ver los posts" -ForegroundColor Cyan
        } else {
            Write-Host ""
            Write-Host "   ⚠️  Hubo un problema al cargar los posts iniciales" -ForegroundColor Yellow
            Write-Host "   Puedes usar el boton 'Actualizar' en el dashboard mas tarde" -ForegroundColor Gray
        }
    } catch {
        Write-Host ""
        Write-Host "   ⚠️  Error al ejecutar el monitor de Telegram" -ForegroundColor Yellow
        Write-Host "   Puedes usar el boton 'Actualizar' en el dashboard mas tarde" -ForegroundColor Gray
    }
    Write-Host ""
}

# ============================================
# 7. ABRIR FRONTEND
# ============================================
Write-Host "🌐 [7/7] Abriendo Dashboard en el navegador..." -ForegroundColor Yellow

# Intentar abrir en el navegador predeterminado
try {
    Start-Process "http://localhost:5000"
    Write-Host "   ✅ Dashboard abierto en http://localhost:5000" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  No se pudo abrir automáticamente" -ForegroundColor Yellow
    Write-Host "   🌐 Abre manualmente: http://localhost:5000" -ForegroundColor Cyan
}
Write-Host ""

# ============================================
# RESUMEN FINAL
# ============================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "   ✅ Sistema iniciado correctamente" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Dashboard:       http://localhost:5000" -ForegroundColor Cyan
Write-Host "🔄 Auto-refresh:    Cada 5 minutos" -ForegroundColor Cyan
Write-Host "🤖 Grupo Telegram:  test-ia-agents" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Usa el botón 'Actualizar' en el dashboard para buscar posts manualmente" -ForegroundColor Yellow
Write-Host "⚠️  No cierres la ventana del backend (servidor Flask)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Para detener todo: Cierra la ventana del backend o presiona Ctrl+C" -ForegroundColor Gray
Write-Host ""
Read-Host "Presiona Enter para salir de este script"
