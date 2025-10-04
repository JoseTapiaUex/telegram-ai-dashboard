# 🔒 Guía de Seguridad - Telegram AI Dashboard

## ⚠️ ARCHIVOS SENSIBLES - NUNCA SUBIR A GIT

### Archivos Críticos Protegidos por `.gitignore`

#### 1. **`.env`** - Credenciales de API ⚠️⚠️⚠️
**Contenido:**
```env
TG_APP_ID=23082217              # ID de aplicación de Telegram
TG_API_HASH=xxxxxxxxxxxxx       # Hash de API de Telegram (SECRETO)
TG_PHONE=+34627733998           # Número de teléfono
TELEGRAM_GROUP_ID=-4945424696   # ID del grupo a monitorear
ANTHROPIC_API_KEY=sk-ant-xxx    # API key de Anthropic (si se usa)
USE_ANTHROPIC=false             # Flag de uso de Anthropic
```

**Riesgo si se expone:**
- 🚨 Acceso completo a tu cuenta de Telegram
- 🚨 Posibilidad de enviar/leer mensajes en tu nombre
- 🚨 Acceso a tu API de Anthropic (costos monetarios)

#### 2. **`*.session`** - Sesiones de Telegram ⚠️⚠️⚠️
**Archivos:**
- `telegram_dashboard_session.session`
- `mcp_integration/telegram_dashboard_session.session`

**Contenido:**
- Tokens de autenticación de Telegram
- Información de sesión activa

**Riesgo si se expone:**
- 🚨 Acceso directo a tu cuenta de Telegram sin necesidad de contraseña
- 🚨 Posibilidad de hacerse pasar por ti
- 🚨 Acceso a todos tus chats y grupos

#### 3. **`*.db` / `*.sqlite`** - Bases de datos ⚠️
**Archivos:**
- `backend/posts.db`

**Contenido:**
- Posts extraídos de Telegram
- URLs y metadatos
- Fechas de procesamiento

**Riesgo si se expone:**
- ⚠️ Información sobre contenido del grupo de Telegram
- ⚠️ Posibles URLs o información sensible compartida en el grupo

#### 4. **`monitor_state.json`** - Estado del monitor ⚠️
**Archivo:**
- `mcp_integration/monitor_state.json`

**Contenido:**
```json
{
  "last_message_id": 12345
}
```

**Riesgo si se expone:**
- ⚠️ Información sobre la actividad del grupo
- ⚠️ Posibilidad de inferir cuántos mensajes hay en el grupo

## ✅ Verificación de Seguridad

### Paso 1: Verificar `.gitignore`

El archivo `.gitignore` DEBE incluir:

```gitignore
# Environment files
.env
.env.*

# Telegram session files
*.session
*.session-journal
telegram_dashboard_session.session
mcp_integration/*.session

# Database files
*.db
*.sqlite
*.sqlite3
backend/*.db

# Monitor state
monitor_state.json
mcp_integration/monitor_state.json
```

### Paso 2: Verificar que git no esté trackeando archivos sensibles

Antes de hacer el primer commit:

```powershell
# Inicializar git (si no está inicializado)
git init

# Verificar qué archivos serán trackeados
git status

# VERIFICAR que NO aparezcan:
# ❌ .env
# ❌ *.session
# ❌ *.db
# ❌ monitor_state.json
```

### Paso 3: Si ya subiste archivos sensibles por error

**URGENTE: Si ya hiciste commit de archivos sensibles:**

```powershell
# Eliminar del historial de git
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# O usar BFG Repo-Cleaner (más rápido)
# https://rtyley.github.io/bfg-repo-cleaner/
```

**DESPUÉS:**
1. 🔄 **Regenerar TODAS las credenciales expuestas**
2. 🔄 Cambiar API keys de Telegram
3. 🔄 Revocar sesiones de Telegram
4. 🔄 Cambiar API key de Anthropic (si se usó)

## 📋 Checklist de Seguridad

Antes de hacer `git push`:

- [ ] ✅ `.gitignore` incluye `.env`
- [ ] ✅ `.gitignore` incluye `*.session`
- [ ] ✅ `.gitignore` incluye `*.db`
- [ ] ✅ `.gitignore` incluye `monitor_state.json`
- [ ] ✅ Verificado con `git status` que no aparecen archivos sensibles
- [ ] ✅ Archivo `.env` NO está en el repositorio
- [ ] ✅ Archivos `.session` NO están en el repositorio
- [ ] ✅ Base de datos NO está en el repositorio
- [ ] ✅ Creado `.env.example` con valores de ejemplo (sin datos reales)

## 📝 Archivo `.env.example` (Seguro para Git)

Crear este archivo como referencia (SIN valores reales):

```env
# Telegram API credentials
# Get them from https://my.telegram.org
TG_APP_ID=your_app_id_here
TG_API_HASH=your_api_hash_here
TG_PHONE=+1234567890

# Telegram group to monitor
# Use list_dialogs.py to get the ID
TELEGRAM_GROUP_ID=-1001234567890

# Anthropic API (optional)
USE_ANTHROPIC=false
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

## 🔐 Mejores Prácticas

### 1. Nunca hardcodees credenciales
❌ **MAL:**
```python
TG_APP_ID = 23082217
TG_API_HASH = "abc123def456"
```

✅ **BIEN:**
```python
TG_APP_ID = os.environ.get("TG_APP_ID")
TG_API_HASH = os.environ.get("TG_API_HASH")
```

### 2. Usa diferentes credenciales para desarrollo y producción
- `.env` - Desarrollo local (no subir)
- `.env.production` - Producción (no subir)
- `.env.example` - Plantilla (sí subir)

### 3. Revoca sesiones periódicamente
1. Ir a Telegram → Settings → Privacy and Security → Active Sessions
2. Revisar sesiones activas
3. Cerrar sesiones no reconocidas

### 4. Rotar API keys regularmente
- Cambiar API keys cada 3-6 meses
- Cambiar inmediatamente si sospechas exposición

### 5. Limita permisos del bot/aplicación
- Solo solicita permisos necesarios
- No compartas API keys entre proyectos

## 🚨 Qué hacer si expusiste credenciales

### Nivel de Urgencia por Tipo de Credencial

#### 🔴 CRÍTICO - Acción inmediata (< 1 hora)
- **Sesiones de Telegram (*.session)**
  1. Ir a Telegram → Settings → Privacy and Security → Active Sessions
  2. Cerrar TODAS las sesiones
  3. Cambiar contraseña de Telegram
  4. Habilitar 2FA si no está activado
  5. Eliminar archivo .session y re-autenticar

- **ANTHROPIC_API_KEY**
  1. Ir a https://console.anthropic.com/settings/keys
  2. Revocar la key expuesta
  3. Generar nueva key
  4. Actualizar .env con la nueva key
  5. Revisar uso facturado por si hubo abuso

#### 🟠 ALTO - Acción urgente (< 24 horas)
- **TG_API_HASH**
  1. Ir a https://my.telegram.org
  2. Eliminar la aplicación comprometida
  3. Crear nueva aplicación
  4. Actualizar TG_APP_ID y TG_API_HASH en .env

#### 🟡 MEDIO - Acción recomendada (< 7 días)
- **TELEGRAM_GROUP_ID**
  - Considerar crear nuevo grupo si el ID es sensible
  - Revisar miembros del grupo por actividad sospechosa

#### 🟢 BAJO - Monitorear
- **monitor_state.json**
  - Simplemente eliminar del repositorio
  - Regenerar en próxima ejecución

## 📚 Referencias de Seguridad

- [Telegram API Security Best Practices](https://core.telegram.org/api/obtaining_api_id)
- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [OWASP: Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

## ✅ Estado Actual del Proyecto

**Última verificación:** 4 de Octubre, 2025

### Archivos Sensibles Presentes:
- ✅ `.env` - PROTEGIDO por .gitignore
- ✅ `telegram_dashboard_session.session` - PROTEGIDO por .gitignore
- ✅ `backend/posts.db` - PROTEGIDO por .gitignore
- ✅ `mcp_integration/monitor_state.json` - PROTEGIDO por .gitignore

### Verificaciones Completadas:
- ✅ `.gitignore` actualizado con todas las protecciones
- ✅ Archivos sensibles listados y documentados
- ✅ Guía de seguridad creada
- ⚠️ **PENDIENTE**: Crear `.env.example` antes del primer commit

---

**⚠️ RECUERDA:** La seguridad es responsabilidad de todos. Revisa este documento antes de cada `git push`.
