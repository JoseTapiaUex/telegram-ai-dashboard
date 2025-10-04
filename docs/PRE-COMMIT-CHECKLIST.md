# ✅ Checklist Pre-Commit - Telegram AI Dashboard

## 🔒 Verificación de Seguridad (OBLIGATORIO)

Antes de hacer tu primer `git add` y `git commit`, verifica:

### 1. ✅ Verificar .gitignore
```powershell
# Debe existir y contener las protecciones
Get-Content .gitignore | Select-String -Pattern ".env|session|.db|monitor_state"
```

**Resultado esperado:** Deben aparecer todas estas líneas.

### 2. ✅ Verificar que archivos sensibles NO estén en git

```powershell
# Inicializar git (si no está inicializado)
git init

# Ver qué archivos serán incluidos
git status
```

**❌ NO DEBEN APARECER:**
- `.env`
- `*.session`
- `*.db`
- `monitor_state.json`

**✅ SÍ DEBEN APARECER:**
- `.env.example`
- `.gitignore`
- `SECURITY.md`
- `README.md`
- Todos los archivos `.py`
- `requirements.txt`
- `frontend/index.html`

### 3. ✅ Verificar contenido de .env.example

```powershell
Get-Content .env.example
```

**Debe contener:**
- ✅ Variables con nombres de ejemplo (`your_api_hash_here`, etc.)
- ❌ NO debe contener valores reales

### 4. ✅ Doble verificación de archivos sensibles

```powershell
# Buscar archivos sensibles en el proyecto
Get-ChildItem -Recurse -File | Where-Object {
    $_.Name -eq ".env" -or 
    $_.Name -like "*.session" -or 
    $_.Name -like "*.db"
} | ForEach-Object { 
    Write-Host "⚠️  $($_.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Red 
}
```

**Todos estos archivos deben estar listados en .gitignore**

## 📝 Flujo de Git Seguro

### Primera vez (inicializar repositorio)

```powershell
# 1. Inicializar git
git init

# 2. Verificar estado
git status

# 3. Si todo está correcto, agregar archivos
git add .

# 4. Verificar qué se agregará (última oportunidad)
git status

# 5. Si aparece algo sensible, detener y revisar .gitignore
# Si todo está bien, hacer commit
git commit -m "Initial commit - Telegram AI Dashboard"

# 6. Conectar con repositorio remoto
git remote add origin https://github.com/JoseTapiaUex/telegram-monitor-mcp.git

# 7. Push al remoto
git push -u origin main
```

### Commits subsecuentes

```powershell
# 1. Verificar cambios
git status

# 2. Agregar archivos específicos (más seguro que git add .)
git add README.md
git add backend/app.py
# etc...

# 3. Commit
git commit -m "Descripción del cambio"

# 4. Push
git push
```

## 🚨 Si Ya Subiste Archivos Sensibles

### URGENTE: Eliminar del historial

```powershell
# Opción 1: Eliminar archivo específico del historial
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# Opción 2: Usar BFG Repo-Cleaner (más rápido)
# Descargar de: https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --delete-files .env
java -jar bfg.jar --delete-files *.session
```

### DESPUÉS de limpiar el historio:

```powershell
# Force push (CUIDADO: reescribe historial)
git push --force --all
```

### REGENERAR Credenciales

1. 🔄 **TG_API_HASH**: Ir a https://my.telegram.org → Eliminar app → Crear nueva
2. 🔄 **Sesiones de Telegram**: Settings → Privacy → Active Sessions → Cerrar todas
3. 🔄 **ANTHROPIC_API_KEY**: https://console.anthropic.com/settings/keys → Revocar → Crear nueva

## 📋 Checklist Visual

Antes de `git push`:

- [ ] ✅ Ejecuté `git status` y revisé todos los archivos
- [ ] ✅ NO aparece `.env` en los archivos staged
- [ ] ✅ NO aparecen archivos `*.session`
- [ ] ✅ NO aparecen archivos `*.db`
- [ ] ✅ SÍ aparece `.env.example` (plantilla)
- [ ] ✅ SÍ aparece `.gitignore` con todas las protecciones
- [ ] ✅ SÍ aparece `SECURITY.md`
- [ ] ✅ Revisé el contenido de `.env.example` (solo ejemplos, no datos reales)
- [ ] ✅ Leí `SECURITY.md` para saber qué hacer en caso de error

## 🎯 Comandos de Verificación Rápida

```powershell
# Ver archivos que git está trackeando
git ls-files

# Buscar si .env está trackeado (NO debe estar)
git ls-files | Select-String ".env"

# Buscar si *.session está trackeado (NO debe estar)
git ls-files | Select-String "session"

# Ver último commit (verificar que no incluya archivos sensibles)
git show --stat
```

## ✅ Aprobación Final

Solo haz `git push` cuando:
- ✅ Verificaste TODO el checklist anterior
- ✅ NO hay archivos sensibles en `git status`
- ✅ Revisaste el último commit con `git show --stat`
- ✅ Leíste `SECURITY.md` al menos una vez

---

**💡 Recuerda:** Es mejor ser paranoico con la seguridad que tener que regenerar todas las credenciales después.

**📖 Más información:** Ver [SECURITY.md](./SECURITY.md)
