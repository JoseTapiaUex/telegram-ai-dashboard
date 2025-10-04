#!/bin/bash

# ============================================================================
# Setup Environment - Configuracion Interactiva de .env
# ============================================================================
# Este script guia al usuario paso a paso para crear su archivo .env
# con todas las credenciales necesarias para el sistema.
# ============================================================================

# Colores ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Funcion para mostrar encabezados
show_header() {
    echo ""
    echo -e "${CYAN}================================================================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}================================================================================${NC}"
    echo ""
}

# Funcion para validar que un valor no este vacio
validate_not_empty() {
    local value="$1"
    local field_name="$2"
    
    if [ -z "$value" ]; then
        echo -e "${RED}ERROR: $field_name no puede estar vacio${NC}"
        return 1
    fi
    return 0
}

# Funcion para validar numero
validate_number() {
    local value="$1"
    local field_name="$2"
    
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}ERROR: $field_name debe ser un numero${NC}"
        return 1
    fi
    return 0
}

# Funcion para validar formato de telefono
validate_phone() {
    local value="$1"
    
    if ! [[ "$value" =~ ^\+[0-9]{10,15}$ ]]; then
        echo -e "${RED}ERROR: Telefono debe tener formato +XX... (ej: +34612345678)${NC}"
        return 1
    fi
    return 0
}

# Funcion para validar ID de grupo (negativo)
validate_group_id() {
    local value="$1"
    
    if ! [[ "$value" =~ ^-[0-9]+$ ]]; then
        echo -e "${RED}ERROR: TELEGRAM_GROUP_ID debe ser un numero negativo${NC}"
        echo -e "${YELLOW}   Los IDs de grupos de Telegram siempre son negativos (ej: -4945424696)${NC}"
        return 1
    fi
    return 0
}

# Verificar si .env ya existe
if [ -f ".env" ]; then
    echo -e "${YELLOW}Ya existe un archivo .env${NC}"
    read -p "Deseas reconfigurarlo? (S/N) [N]: " overwrite
    
    if [ "$overwrite" != "S" ] && [ "$overwrite" != "s" ]; then
        echo -e "${GREEN}Manteniendo configuracion existente${NC}"
        exit 0
    fi
    
    # Hacer backup del .env existente
    timestamp=$(date +"%Y%m%d_%H%M%S")
    cp ".env" ".env.backup_$timestamp"
    echo -e "${CYAN}Backup creado: .env.backup_$timestamp${NC}"
fi

# ============================================================================
# BIENVENIDA
# ============================================================================
clear
show_header "CONFIGURACION INICIAL - Telegram AI Dashboard"

echo -e "${WHITE}Este asistente te guiara para configurar tu archivo .env${NC}"
echo ""
echo -e "${YELLOW}Necesitaras:${NC}"
echo -e "${WHITE}  1. Credenciales de Telegram API (https://my.telegram.org/auth)${NC}"
echo -e "${WHITE}  2. Tu numero de telefono de Telegram${NC}"
echo -e "${WHITE}  3. ID del grupo que quieres monitorear${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER para continuar...${NC}"
read

# ============================================================================
# PASO 1: CREDENCIALES DE TELEGRAM API
# ============================================================================
show_header "PASO 1/4: Credenciales de Telegram API"

echo -e "${YELLOW}Para obtener tus credenciales:${NC}"
echo -e "${WHITE}  1. Ve a: https://my.telegram.org/auth${NC}"
echo -e "${WHITE}  2. Inicia sesion con tu numero de telefono${NC}"
echo -e "${WHITE}  3. Ve a 'API Development Tools'${NC}"
echo -e "${WHITE}  4. Crea una nueva aplicacion (si no tienes una)${NC}"
echo -e "${WHITE}  5. Copia api_id y api_hash${NC}"
echo ""

# Pedir TG_APP_ID
while true; do
    read -p "Ingresa tu TG_APP_ID (api_id): " TG_APP_ID
    validate_not_empty "$TG_APP_ID" "TG_APP_ID" && validate_number "$TG_APP_ID" "TG_APP_ID" && break
done

# Pedir TG_API_HASH
while true; do
    read -p "Ingresa tu TG_API_HASH (api_hash): " TG_API_HASH
    validate_not_empty "$TG_API_HASH" "TG_API_HASH" && break
done

# Pedir TG_PHONE
while true; do
    echo ""
    echo -e "${YELLOW}Formato del telefono: +[codigo pais][numero]${NC}"
    echo -e "${GRAY}Ejemplos: +34612345678 (Espana), +1234567890 (EE.UU.)${NC}"
    read -p "Ingresa tu numero de telefono: " TG_PHONE
    validate_not_empty "$TG_PHONE" "TG_PHONE" && validate_phone "$TG_PHONE" && break
done

echo ""
echo -e "${GREEN}Credenciales de Telegram API configuradas${NC}"

# ============================================================================
# PASO 2: CREAR .env TEMPORAL Y EJECUTAR list_dialogs.py
# ============================================================================
show_header "PASO 2/4: Identificar el Grupo a Monitorear"

echo -e "${CYAN}Creando archivo .env temporal...${NC}"

# Crear .env temporal con las credenciales basicas
cat > .env << EOF
# Telegram API Credentials
TG_APP_ID=$TG_APP_ID
TG_API_HASH=$TG_API_HASH
TG_PHONE=$TG_PHONE

# Telegram Group to Monitor
TELEGRAM_GROUP_ID=

# Anthropic API (Optional - Currently not in use)
USE_ANTHROPIC=false
ANTHROPIC_API_KEY=
EOF

echo -e "${GREEN}Archivo .env temporal creado${NC}"
echo ""
echo -e "${CYAN}Conectando a Telegram para listar tus grupos...${NC}"
echo -e "${YELLOW}Si es tu primera vez, Telegram te pedira un codigo de verificacion${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER para continuar...${NC}"
read

# Ejecutar list_dialogs.py
echo ""
echo -e "${CYAN}================================================================================${NC}"
export PYTHONIOENCODING='utf-8'
if python3 mcp_integration/list_dialogs.py; then
    list_dialogs_success=true
else
    echo -e "${RED}ERROR al listar dialogos${NC}"
    list_dialogs_success=false
fi
echo -e "${CYAN}================================================================================${NC}"
echo ""

if [ "$list_dialogs_success" != "true" ]; then
    echo -e "${YELLOW}No se pudieron listar los grupos automaticamente${NC}"
    echo -e "${GRAY}   Puedes ejecutar manualmente: python3 mcp_integration/list_dialogs.py${NC}"
    echo ""
fi

# ============================================================================
# PASO 3: PEDIR TELEGRAM_GROUP_ID
# ============================================================================
show_header "PASO 3/4: Seleccionar Grupo"

echo -e "${YELLOW}De la tabla anterior, copia el ID del grupo que quieres monitorear.${NC}"
echo -e "${GRAY}Recuerda: Los IDs de grupos siempre son NEGATIVOS (ej: -4945424696)${NC}"
echo ""

# Pedir TELEGRAM_GROUP_ID
while true; do
    read -p "Ingresa el TELEGRAM_GROUP_ID: " TELEGRAM_GROUP_ID
    validate_not_empty "$TELEGRAM_GROUP_ID" "TELEGRAM_GROUP_ID" && validate_group_id "$TELEGRAM_GROUP_ID" && break
done

echo ""
echo -e "${GREEN}Grupo seleccionado: $TELEGRAM_GROUP_ID${NC}"

# ============================================================================
# PASO 4: ANTHROPIC API (OPCIONAL)
# ============================================================================
show_header "PASO 4/4: Anthropic API (Opcional)"

echo -e "${WHITE}El sistema puede usar Claude AI de Anthropic para mejorar los resumenes.${NC}"
echo -e "${YELLOW}Actualmente esta funcion esta DESHABILITADA por defecto${NC}"
echo ""

read -p "Deseas habilitar Anthropic API? (S/N) [N]: " use_anthropic

if [ "$use_anthropic" == "S" ] || [ "$use_anthropic" == "s" ]; then
    echo ""
    echo -e "${GRAY}Obten tu API Key en: https://console.anthropic.com/settings/keys${NC}"
    read -p "Ingresa tu ANTHROPIC_API_KEY: " ANTHROPIC_API_KEY
    
    if validate_not_empty "$ANTHROPIC_API_KEY" "ANTHROPIC_API_KEY"; then
        USE_ANTHROPIC="true"
        echo -e "${GREEN}Anthropic API habilitada${NC}"
    else
        USE_ANTHROPIC="false"
        ANTHROPIC_API_KEY=""
        echo -e "${YELLOW}API Key vacia, Anthropic quedara deshabilitado${NC}"
    fi
else
    USE_ANTHROPIC="false"
    ANTHROPIC_API_KEY=""
    echo -e "${GREEN}Anthropic API deshabilitada (configuracion por defecto)${NC}"
fi

# ============================================================================
# CREAR .env FINAL
# ============================================================================
show_header "Guardando Configuracion"

cat > .env << EOF
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
EOF

echo -e "${GREEN}Archivo .env creado exitosamente${NC}"

# ============================================================================
# RESUMEN FINAL
# ============================================================================
show_header "RESUMEN DE CONFIGURACION"

echo -e "${GRAY}TG_APP_ID:         ${WHITE}$TG_APP_ID${NC}"
echo -e "${GRAY}TG_API_HASH:       ${WHITE}${TG_API_HASH:0:10}...${NC}"
echo -e "${GRAY}TG_PHONE:          ${WHITE}$TG_PHONE${NC}"
echo -e "${GRAY}TELEGRAM_GROUP_ID: ${WHITE}$TELEGRAM_GROUP_ID${NC}"

if [ "$USE_ANTHROPIC" == "true" ]; then
    echo -e "${GRAY}USE_ANTHROPIC:     ${GREEN}Habilitado${NC}"
else
    echo -e "${GRAY}USE_ANTHROPIC:     ${YELLOW}Deshabilitado${NC}"
fi

echo ""
echo -e "${CYAN}================================================================================${NC}"
echo ""
echo -e "${GREEN}Configuracion completada exitosamente!${NC}"
echo ""
echo -e "${YELLOW}Proximos pasos:${NC}"
echo -e "${WHITE}  1. El sistema continuara con la instalacion automatica${NC}"
echo -e "${WHITE}  2. Se iniciara el backend Flask${NC}"
echo -e "${WHITE}  3. Se abrira el dashboard en tu navegador${NC}"
echo ""
echo -e "${CYAN}NOTA: Tu archivo .env esta protegido por .gitignore${NC}"
echo -e "${CYAN}   No se subira a GitHub (tus credenciales estan seguras)${NC}"
echo ""
echo -e "${CYAN}================================================================================${NC}"
echo ""
