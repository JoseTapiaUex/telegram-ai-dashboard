#!/bin/bash
# Telegram AI Dashboard - Startup Script
# Configura el entorno, instala dependencias, inicia backend y abre el frontend
# Compatible con macOS y Linux

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}   🤖 Telegram AI Dashboard - Startup Script   ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Cambiar al directorio del script
cd "$(dirname "$0")"
PROJECT_DIR=$(pwd)

# ============================================
# 1. VERIFICAR PYTHON
# ============================================
echo -e "${YELLOW}🔍 [1/5] Verificando Python...${NC}"
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    PYTHON_VERSION=$(python3 --version)
    echo -e "   ${GREEN}✅ Python encontrado: $PYTHON_VERSION${NC}"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
    PYTHON_VERSION=$(python --version)
    echo -e "   ${GREEN}✅ Python encontrado: $PYTHON_VERSION${NC}"
else
    echo -e "   ${RED}❌ Python no está instalado${NC}"
    echo -e "   ${YELLOW}📥 Instala Python 3.8+ desde: https://www.python.org/downloads/${NC}"
    exit 1
fi
echo ""

# ============================================
# 2. INSTALAR DEPENDENCIAS
# ============================================
echo -e "${YELLOW}📦 [2/5] Verificando dependencias...${NC}"

# Verificar requirements.txt raíz
if [ -f "requirements.txt" ]; then
    echo -e "   ${CYAN}📄 Instalando dependencias principales...${NC}"
    $PYTHON_CMD -m pip install -q -r requirements.txt
    echo -e "   ${GREEN}✅ Dependencias principales instaladas${NC}"
else
    echo -e "   ${YELLOW}⚠️  requirements.txt no encontrado${NC}"
fi

# Verificar requirements.txt del backend
if [ -f "backend/requirements.txt" ]; then
    echo -e "   ${CYAN}📄 Instalando dependencias del backend...${NC}"
    $PYTHON_CMD -m pip install -q -r backend/requirements.txt
    echo -e "   ${GREEN}✅ Dependencias del backend instaladas${NC}"
fi

# Instalar Playwright browsers si es necesario
echo -e "   ${CYAN}🌐 Verificando Playwright...${NC}"
if $PYTHON_CMD -c "from playwright.sync_api import sync_playwright" 2>/dev/null; then
    echo -e "   ${GREEN}✅ Playwright ya configurado${NC}"
else
    echo -e "   ${CYAN}📥 Instalando navegadores de Playwright...${NC}"
    $PYTHON_CMD -m playwright install chromium
    echo -e "   ${GREEN}✅ Playwright configurado${NC}"
fi
echo ""

# ============================================
# 3. VERIFICAR CONFIGURACIÓN
# ============================================
echo -e "${YELLOW}⚙️  [3/5] Verificando configuración...${NC}"

if [ ! -f ".env" ]; then
    echo -e "   ${RED}⚠️  Archivo .env no encontrado${NC}"
    echo -e "   ${YELLOW}📝 Copia .env.example a .env y configura tus credenciales${NC}"
    
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "   ${GREEN}✅ Archivo .env creado desde .env.example${NC}"
        echo -e "   ${YELLOW}🔧 IMPORTANTE: Edita .env con tus credenciales de Telegram${NC}"
        echo ""
        read -p "Presiona Enter cuando hayas configurado .env..."
    else
        echo -e "   ${RED}❌ No se puede continuar sin configuración${NC}"
        exit 1
    fi
else
    echo -e "   ${GREEN}✅ Archivo .env encontrado${NC}"
fi
echo ""

# ============================================
# 4. INICIAR BACKEND
# ============================================
echo -e "${YELLOW}🚀 [4/5] Iniciando Backend Flask...${NC}"

# Verificar si el puerto 5000 está en uso
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "   ${YELLOW}⚠️  Puerto 5000 ya en uso. Deteniendo proceso anterior...${NC}"
    PID=$(lsof -ti:5000)
    kill -9 $PID 2>/dev/null || true
    sleep 2
fi

# Iniciar backend en background
export PYTHONIOENCODING='utf-8'
cd backend
echo -e "   ${CYAN}⏳ Iniciando servidor Flask...${NC}"

# Detectar sistema operativo para abrir terminal
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    osascript -e "tell application \"Terminal\" to do script \"cd '$PROJECT_DIR/backend' && export PYTHONIOENCODING='utf-8' && echo '' && echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && echo '   Flask Backend Server   ' && echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && echo '' && echo '🌐 Servidor: http://localhost:5000' && echo '🔄 Auto-refresh: Cada 5 minutos' && echo '⚠️  No cierres esta ventana' && echo '' && $PYTHON_CMD app.py\""
else
    # Linux
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal -- bash -c "cd '$PROJECT_DIR/backend' && export PYTHONIOENCODING='utf-8' && echo '' && echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && echo '   Flask Backend Server   ' && echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && echo '' && echo '🌐 Servidor: http://localhost:5000' && echo '🔄 Auto-refresh: Cada 5 minutos' && echo '⚠️  No cierres esta ventana' && echo '' && $PYTHON_CMD app.py; exec bash"
    elif command -v xterm &> /dev/null; then
        xterm -e "cd '$PROJECT_DIR/backend' && export PYTHONIOENCODING='utf-8' && $PYTHON_CMD app.py" &
    else
        # Fallback: ejecutar en background
        nohup $PYTHON_CMD app.py > ../backend.log 2>&1 &
        echo -e "   ${YELLOW}⚠️  Backend ejecutándose en background (log: backend.log)${NC}"
    fi
fi

cd "$PROJECT_DIR"

# Esperar a que el backend inicie
echo -e "   ${CYAN}⏳ Esperando que el backend inicie...${NC}"
TIMEOUT=15
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    sleep 1
    ELAPSED=$((ELAPSED + 1))
    if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo -e "   ${GREEN}✅ Backend iniciado en http://localhost:5000${NC}"
        break
    fi
    if [ $ELAPSED -eq $TIMEOUT ]; then
        echo -e "   ${RED}❌ Timeout esperando el backend${NC}"
        exit 1
    fi
done
echo ""

# ============================================
# 5. ABRIR FRONTEND
# ============================================
echo -e "${YELLOW}🌐 [5/5] Abriendo Dashboard en el navegador...${NC}"

# Detectar sistema operativo para abrir navegador
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open "http://localhost:5000"
    echo -e "   ${GREEN}✅ Dashboard abierto en http://localhost:5000${NC}"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:5000" &> /dev/null &
        echo -e "   ${GREEN}✅ Dashboard abierto en http://localhost:5000${NC}"
    else
        echo -e "   ${YELLOW}⚠️  No se pudo abrir automáticamente${NC}"
        echo -e "   ${CYAN}🌐 Abre manualmente: http://localhost:5000${NC}"
    fi
fi
echo ""

# ============================================
# RESUMEN FINAL
# ============================================
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}   ✅ Sistema iniciado correctamente${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}📊 Dashboard:       http://localhost:5000${NC}"
echo -e "${CYAN}🔄 Auto-refresh:    Cada 5 minutos${NC}"
echo -e "${CYAN}🤖 Grupo Telegram:  test-ia-agents${NC}"
echo ""
echo -e "${YELLOW}💡 Usa el botón 'Actualizar' en el dashboard para buscar posts manualmente${NC}"
echo -e "${YELLOW}⚠️  No cierres la ventana del backend (servidor Flask)${NC}"
echo ""
echo -e "Para detener todo: Cierra la ventana del backend o ejecuta: kill -9 \$(lsof -ti:5000)"
echo ""
read -p "Presiona Enter para salir de este script..."
