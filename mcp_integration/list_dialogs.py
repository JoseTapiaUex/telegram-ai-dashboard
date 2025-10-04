"""
🔧 HERRAMIENTA AUXILIAR: Lista todos tus diálogos/chats de Telegram

Propósito:
  - Listar todos tus chats, grupos y canales de Telegram
  - Obtener los IDs de grupos para configurar TELEGRAM_GROUP_ID en .env
  - Verificar la autenticación de Telegram

Uso:
  python mcp_integration/list_dialogs.py

Requisitos:
  - TG_APP_ID, TG_API_HASH y TG_PHONE configurados en .env
  - Sesión de Telegram autenticada (o autenticación durante la ejecución)

Ejemplo de salida:
  ID              Tipo         Nombre                                   Mensajes sin leer
  ------------------------------------------------------------------------------------------------
  -4945424696     Grupo        test-ia-agents                          0
  -1001234567890  Supergrupo   Mi Grupo de Desarrollo                  5
  123456789       Usuario      Juan Pérez                              2
"""
import os
from telethon import TelegramClient
from telethon.sessions import StringSession

# Intentar cargar .env
try:
    from dotenv import load_dotenv
    load_dotenv()
except:
    pass

# Leer credenciales desde variables de entorno
TG_APP_ID = int(os.environ.get("TG_APP_ID", "0"))
TG_API_HASH = os.environ.get("TG_API_HASH", "")
TG_PHONE = os.environ.get("TG_PHONE", "")

# Ruta de sesión (la misma que usa telegram-mcp)
session_path = os.environ.get("TG_SESSION_PATH", os.path.expanduser("~/.telegram-mcp/session.json"))

if not (TG_APP_ID and TG_API_HASH):
    print("Error: TG_APP_ID y TG_API_HASH deben estar configurados.")
    exit(1)

async def list_dialogs():
    """Lista todos los diálogos/chats disponibles"""
    # Crear cliente (usamos una sesión local en el mismo directorio que este script)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    session_name = os.path.join(script_dir, "telegram_dashboard_session")
    
    client = TelegramClient(session_name, TG_APP_ID, TG_API_HASH)
    
    await client.connect()
    
    # Si no está autorizado, autenticamos con el teléfono
    if not await client.is_user_authorized():
        print(f"Autenticando con el número: {TG_PHONE}")
        await client.send_code_request(TG_PHONE)
        code = input("Introduce el código que recibiste por SMS: ")
        await client.sign_in(TG_PHONE, code)
        print("✅ Autenticación exitosa!")
    
    print("🔍 Listando diálogos de Telegram...\n")
    print(f"{'ID':<15} {'Tipo':<12} {'Nombre':<40} {'Mensajes sin leer':<20}")
    print("-" * 100)
    
    dialogs = await client.get_dialogs(limit=50)
    
    for dialog in dialogs:
        dialog_id = dialog.id
        dialog_name = dialog.name or dialog.title or "Sin nombre"
        unread_count = dialog.unread_count
        
        # Determinar tipo
        if dialog.is_user:
            dialog_type = "Usuario"
        elif dialog.is_group:
            dialog_type = "Grupo"
        elif dialog.is_channel:
            dialog_type = "Canal"
        else:
            dialog_type = "Otro"
        
        print(f"{dialog_id:<15} {dialog_type:<12} {dialog_name:<40} {unread_count:<20}")
    
    print("\n✅ Lista completada. Usa el ID o nombre del chat en TELEGRAM_GROUP_ID.")
    
    await client.disconnect()

if __name__ == "__main__":
    import asyncio
    asyncio.run(list_dialogs())
