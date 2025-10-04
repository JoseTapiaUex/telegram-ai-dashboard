import os
import json
import re
import requests
from datetime import datetime
from urllib.parse import urlparse

# Importaciones opcionales
try:
    import anthropic
except ImportError:
    anthropic = None

# Archivo para guardar el estado del monitor (último mensaje procesado)
STATE_FILE = os.path.join(os.path.dirname(__file__), 'monitor_state.json')

# Intentar cargar variables desde un archivo .env (opcional)
try:
    from dotenv import load_dotenv
    load_dotenv()
except Exception:
    # python-dotenv no está instalado o no se pudo cargar; continuamos usando os.environ
    pass

# Control de uso de Anthropic: por defecto true. Si quieres evitar Anthropic, pon USE_ANTHROPIC=false
USE_ANTHROPIC = os.environ.get("USE_ANTHROPIC", "true").lower() in ("1", "true", "yes")

ANTHROPIC_API_KEY = os.environ.get("ANTHROPIC_API_KEY")
if USE_ANTHROPIC:
    if not ANTHROPIC_API_KEY:
        raise RuntimeError("ANTHROPIC_API_KEY no está configurada en las variables de entorno.")
    if anthropic is None:
        raise RuntimeError("La librería 'anthropic' no está instalada pero USE_ANTHROPIC está activado.")
    client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
    MODEL_NAME = os.environ.get("MODEL_NAME", "claude-sonnet-4-20250514")

# ID del grupo de Telegram (puede definirse en .env)
TELEGRAM_GROUP_ID = os.environ.get("TELEGRAM_GROUP_ID", "test-ia-agents")
# Credenciales de Telegram (leídas desde variables de entorno)
TG_APP_ID = os.environ.get("TG_APP_ID")
TG_API_HASH = os.environ.get("TG_API_HASH")
TG_PHONE = os.environ.get("TG_PHONE")

if not (TG_APP_ID and TG_API_HASH and TG_PHONE):
    # Solo advertimos; el proceso puede seguir si la integración MCP ya está autenticada en el host
    print("Advertencia: TG_APP_ID, TG_API_HASH o TG_PHONE no están configurados en las variables de entorno. Asegúrate de configurarlos localmente si necesitas autenticar el MCP.")

def load_state():
    """Carga el estado del monitor (último mensaje procesado)"""
    if os.path.exists(STATE_FILE):
        try:
            with open(STATE_FILE, 'r') as f:
                return json.load(f)
        except:
            pass
    return {'last_message_id': 0}

def save_state(state):
    """Guarda el estado del monitor"""
    try:
        with open(STATE_FILE, 'w') as f:
            json.dump(state, f, indent=2)
    except Exception as e:
        print(f"Error guardando estado: {e}")

def extract_urls(text):
    """Extrae URLs de un texto"""
    url_pattern = r'https?://[^\s]+'
    return re.findall(url_pattern, text)

def get_telegram_messages():
    """Obtiene mensajes del grupo usando MCP"""
    # Modo Anthropic (por defecto)
    if USE_ANTHROPIC:
        try:
            response = client.messages.create(
                model=MODEL_NAME,
                max_tokens=4096,
                tools=[{
                    "type": "computer_20241022",
                    "name": "tg_dialog",
                    "display_name": "Telegram Dialog",
                    "display_width_px": 1024,
                    "display_height_px": 768,
                    "display_number": 1,
                }],
                messages=[{
                    "role": "user",
                    "content": f"Obtén los últimos 50 mensajes del grupo {TELEGRAM_GROUP_ID} usando la herramienta tg_dialog"
                }]
            )

            # Procesar respuesta y extraer mensajes con URLs
            messages_with_urls = []
            for block in response.content:
                if block.type == "tool_use":
                    result = json.loads(block.content)
                    for message in result.get('messages', []):
                        urls = extract_urls(message.get('text', ''))
                        if urls:
                            messages_with_urls.append({
                                'id': message.get('id'),
                                'sender': message.get('from_user', {}).get('username', 'Unknown'),
                                'time': datetime.fromtimestamp(message.get('date', 0)).strftime('%Y-%m-%d %H:%M:%S'),
                                'text': message.get('text', ''),
                                'urls': urls,
                                'status': 'pending',
                                'processed': False
                            })

            return messages_with_urls

        except Exception as e:
            print(f"Error obteniendo mensajes: {e}")
            return []

    # Modo local: usar telethon para obtener mensajes directamente
    try:
        from telethon import TelegramClient
        import asyncio
        
        async def fetch_messages_telethon():
            # Cargar el estado para saber desde qué mensaje obtener
            state = load_state()
            last_message_id = state.get('last_message_id', 0)
            
            # Usar ruta absoluta para la sesión (en el directorio del script)
            import sys
            script_dir = os.path.dirname(os.path.abspath(__file__))
            session_name = os.path.join(script_dir, "telegram_dashboard_session")
            client = TelegramClient(session_name, int(TG_APP_ID), TG_API_HASH)
            await client.connect()
            
            if not await client.is_user_authorized():
                print("Error: sesión de telethon no autorizada. Ejecuta list_dialogs.py primero.")
                await client.disconnect()
                return []
            
            messages_with_urls = []
            max_message_id = last_message_id
            
            # Obtener mensajes del grupo/chat (solo los más recientes que el último procesado)
            async for message in client.iter_messages(int(TELEGRAM_GROUP_ID), limit=50, min_id=last_message_id):
                if message.text:
                    urls = extract_urls(message.text)
                    if urls:
                        sender_name = "Unknown"
                        if message.sender:
                            sender_name = getattr(message.sender, 'username', None) or getattr(message.sender, 'first_name', 'Unknown')
                        
                        messages_with_urls.append({
                            'id': message.id,
                            'sender': sender_name,
                            'time': message.date.strftime('%Y-%m-%d %H:%M:%S') if message.date else 'Unknown',
                            'text': message.text,
                            'urls': urls,
                            'status': 'pending',
                            'processed': False
                        })
                    
                    # Actualizar el ID máximo encontrado
                    if message.id > max_message_id:
                        max_message_id = message.id
            
            await client.disconnect()
            
            # Guardar el nuevo ID máximo procesado
            if max_message_id > last_message_id:
                state['last_message_id'] = max_message_id
                save_state(state)
                print(f"💾 Estado guardado: último mensaje procesado ID {max_message_id}")
            
            return messages_with_urls
        
        return asyncio.run(fetch_messages_telethon())

    except Exception as e:
        print(f"Error obteniendo mensajes localmente: {e}")
        import traceback
        traceback.print_exc()
        return []

def extract_twitter_content(url, soup):
    """Extrae contenido específico de tweets de X.com/Twitter"""
    try:
        # Intentar extraer el texto del tweet desde diferentes fuentes
        tweet_text = None
        
        # 1. Buscar en meta tags de Twitter Card
        if soup.find('meta', attrs={'property': 'og:description'}):
            tweet_text = soup.find('meta', attrs={'property': 'og:description'}).get('content', '')
        elif soup.find('meta', attrs={'name': 'description'}):
            tweet_text = soup.find('meta', attrs={'name': 'description'}).get('content', '')
        
        # 2. Limpiar el texto del tweet
        if tweet_text:
            # Remover mensajes de error comunes de X.com
            if 'JavaScript is disabled' in tweet_text or 'enable JavaScript' in tweet_text:
                tweet_text = None
        
        # 3. Extraer el autor del tweet
        author = "Usuario de X"
        if soup.find('meta', attrs={'property': 'og:title'}):
            og_title = soup.find('meta', attrs={'property': 'og:title'}).get('content', '')
            # El formato suele ser "Usuario on X: texto del tweet"
            if ' on X:' in og_title or ' en X:' in og_title:
                author = og_title.split(' on X:')[0].split(' en X:')[0].strip()
        
        # 4. Extraer imagen del tweet
        image_url = None
        if soup.find('meta', attrs={'property': 'og:image'}):
            image_url = soup.find('meta', attrs={'property': 'og:image'}).get('content')
        
        return {
            'text': tweet_text,
            'author': author,
            'image_url': image_url
        }
    except Exception as e:
        print(f"Error extrayendo contenido de Twitter: {e}")
        return None

def process_url_content(url, message_date=None):
    """Procesa una URL y extrae información usando Claude o localmente"""
    # Si no se proporciona fecha del mensaje, usar la fecha actual
    if message_date is None:
        message_date = datetime.now().strftime('%Y-%m-%d')
    
    if USE_ANTHROPIC:
        # Modo Anthropic: usar Claude para análisis
        try:
            response = client.messages.create(
                model=MODEL_NAME,
                max_tokens=2048,
                messages=[{
                    "role": "user",
                    "content": f"""Analiza el contenido de esta URL: {url}
                    
Extrae la siguiente información en formato JSON:
- title: título del artículo
- summary: resumen de 2-3 frases
- provider: nombre del sitio/fuente
- type: tipo de contenido (Noticia, Artículo, Blog, etc.)
- image_url: URL de la imagen principal (si está disponible)

Responde SOLO con el JSON, sin texto adicional."""
                }]
            )
            
            content = response.content[0].text
            # Extraer JSON de la respuesta
            json_match = re.search(r'\{.*\}', content, re.DOTALL)
            if json_match:
                data = json.loads(json_match.group())
                data['source_url'] = url
                data['release_date'] = message_date
                return data
            
            return None
        
        except Exception as e:
            print(f"Error procesando URL {url}: {e}")
            return None
    
    # Modo local: scraping básico con requests + BeautifulSoup
    try:
        from bs4 import BeautifulSoup
        
        # Headers más completos para evitar bloqueos
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'none'
        }
        response = requests.get(url, headers=headers, timeout=15, allow_redirects=True)
        
        # Variable para controlar si necesitamos Playwright
        use_playwright = False
        playwright_reason = ""
        
        # Si recibimos 202, 403 o página vacía, intentar con Playwright (fallback con navegador real)
        if response.status_code in [202, 403] or len(response.content) < 500:
            use_playwright = True
            playwright_reason = f"status: {response.status_code}"
        
        if use_playwright:
            print(f"⚠️ Sitio con protección detectada ({playwright_reason}). Intentando con Playwright...")
            try:
                from playwright.sync_api import sync_playwright
                
                with sync_playwright() as p:
                    print(f"🔄 Abriendo navegador para {urlparse(url).netloc}...")
                    browser = p.chromium.launch(
                        headless=True,
                        args=[
                            '--disable-blink-features=AutomationControlled',
                            '--disable-dev-shm-usage',
                            '--no-sandbox'
                        ]
                    )
                    
                    # Configurar contexto con user-agent realista
                    context = browser.new_context(
                        user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                        viewport={'width': 1920, 'height': 1080},
                        locale='es-ES',
                        timezone_id='Europe/Madrid',
                        extra_http_headers={
                            'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
                            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
                        }
                    )
                    
                    page = context.new_page()
                    
                    # Ocultar propiedades de webdriver
                    page.add_init_script("""
                        Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                        Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                        Object.defineProperty(navigator, 'languages', {get: () => ['es-ES', 'es']});
                    """)
                    
                    page.goto(url, wait_until='networkidle', timeout=30000)
                    
                    # Esperar a que cargue el contenido
                    page.wait_for_timeout(3000)
                    
                    # Obtener HTML renderizado
                    html_content = page.content()
                    browser.close()
                    
                    soup = BeautifulSoup(html_content, 'html.parser')
                    print(f"✅ Contenido obtenido con Playwright")
                
            except Exception as e:
                print(f"❌ Error con Playwright: {e}")
                # Si falla Playwright, devolver mensaje de error amigable
                return {
                    'title': f"Contenido de {urlparse(url).netloc}",
                    'summary': "Este sitio web tiene protección avanzada. Visita el enlace directamente para ver el contenido completo.",
                    'provider': urlparse(url).netloc.replace('www.', '').split('.')[0].title(),
                    'type': 'Artículo',
                    'image_url': f"https://api.dicebear.com/7.x/shapes/svg?seed={hash(url) % 10000}",
                    'source_url': url,
                    'release_date': message_date
                }
        else:
            response.raise_for_status()
            soup = BeautifulSoup(response.content, 'html.parser')
        
        # Detectar si es X.com/Twitter y usar extracción especial
        domain_lower = urlparse(url).netloc.lower()
        is_twitter = any(x in domain_lower for x in ['x.com', 'twitter.com'])
        image_url = None  # Inicializar image_url para todos los casos
        
        if is_twitter:
            twitter_data = extract_twitter_content(url, soup)
            if twitter_data and twitter_data.get('text'):
                # Usar datos extraídos de Twitter
                title = f"{twitter_data['author']}"
                summary = twitter_data['text'][:500]
                image_url = twitter_data.get('image_url')
            else:
                # Fallback si no se pudo extraer
                title = "Tweet de X"
                summary = "Contenido no disponible. Visita el enlace para ver el tweet completo."
                image_url = None
        else:
            # Extraer título con prioridad: og:title > twitter:title > title tag > h1
            title = None
            if soup.find('meta', property='og:title'):
                title = soup.find('meta', property='og:title').get('content')
            elif soup.find('meta', attrs={'name': 'twitter:title'}):
                title = soup.find('meta', attrs={'name': 'twitter:title'}).get('content')
            elif soup.find('title'):
                title = soup.find('title').get_text().strip()
            elif soup.find('h1'):
                title = soup.find('h1').get_text().strip()
            else:
                # Usar el dominio como título
                title = f"Artículo de {urlparse(url).netloc.replace('www.', '')}"
            
            # Limpiar el título
            if title:
                title = title.strip()
                # Si el título está vacío después de limpiar
                if not title or title == "":
                    title = f"Contenido de {urlparse(url).netloc.replace('www.', '')}"
            
            # Extraer descripción/summary con múltiples fuentes
            summary = None
            if soup.find('meta', property='og:description'):
                summary = soup.find('meta', property='og:description').get('content')
            elif soup.find('meta', attrs={'name': 'twitter:description'}):
                summary = soup.find('meta', attrs={'name': 'twitter:description'}).get('content')
            elif soup.find('meta', attrs={'name': 'description'}):
                summary = soup.find('meta', attrs={'name': 'description'}).get('content')
            else:
                # Intentar extraer del primer párrafo o artículo
                content_text = None
                
                # Buscar en article, main, o directamente p
                article = soup.find('article')
                if article:
                    paragraphs = article.find_all('p')
                    if paragraphs:
                        content_text = ' '.join([p.get_text().strip() for p in paragraphs[:3]])[:400]
                
                if not content_text:
                    main = soup.find('main')
                    if main:
                        paragraphs = main.find_all('p')
                        if paragraphs:
                            content_text = ' '.join([p.get_text().strip() for p in paragraphs[:3]])[:400]
                
                if not content_text:
                    paragraphs = soup.find_all('p')
                    if len(paragraphs) > 0:
                        # Buscar párrafos con contenido sustancial (más de 50 caracteres)
                        for p in paragraphs:
                            text = p.get_text().strip()
                            if len(text) > 50:
                                content_text = text[:400]
                                break
                
                summary = content_text if content_text else "Visita el enlace para ver el contenido completo."
            
            # Limpiar descripciones con mensajes de error de JavaScript
            if summary and ('JavaScript is disabled' in summary or 'enable JavaScript' in summary):
                summary = "Contenido no disponible. Visita el enlace para ver más detalles."
        
        # Extraer proveedor con nombre más descriptivo
        provider = None
        if soup.find('meta', property='og:site_name'):
            provider = soup.find('meta', property='og:site_name').get('content')
        elif soup.find('meta', attrs={'name': 'twitter:site'}):
            provider = soup.find('meta', attrs={'name': 'twitter:site'}).get('content').lstrip('@')
        else:
            # Usar el dominio como fallback
            domain = urlparse(url).netloc
            provider = domain.replace('www.', '').split('.')[0].title()
        
        # Extraer imagen con múltiples estrategias (solo si no es Twitter o no se extrajo antes)
        if not is_twitter or not image_url:
            # 1. Open Graph image
            if soup.find('meta', property='og:image'):
                image_url = soup.find('meta', property='og:image').get('content')
            # 2. Twitter card image
            elif soup.find('meta', attrs={'name': 'twitter:image'}):
                image_url = soup.find('meta', attrs={'name': 'twitter:image'}).get('content')
            # 3. Link rel image_src
            elif soup.find('link', rel='image_src'):
                image_url = soup.find('link', rel='image_src').get('href')
            # 4. Primera imagen grande en el contenido
            elif soup.find('img'):
                for img in soup.find_all('img'):
                    img_src = img.get('src')
                    if img_src and not any(x in img_src.lower() for x in ['logo', 'icon', 'avatar', 'pixel']):
                        # Convertir URL relativa a absoluta
                        if img_src.startswith('//'):
                            image_url = 'https:' + img_src
                        elif img_src.startswith('/'):
                            parsed = urlparse(url)
                            image_url = f"{parsed.scheme}://{parsed.netloc}{img_src}"
                        elif img_src.startswith('http'):
                            image_url = img_src
                        if image_url:
                            break
        
        # 5. Si no hay imagen, generar una usando un servicio de placeholders
        if not image_url:
            # Usar DiceBear API para generar una imagen basada en el título
            title_hash = hash(title) % 10000
            image_url = f"https://api.dicebear.com/7.x/shapes/svg?seed={title_hash}"
        
        # Determinar tipo de contenido basado en el dominio y meta tags
        content_type = 'Artículo'
        domain_lower = urlparse(url).netloc.lower()
        
        # Verificar meta tags de tipo
        if soup.find('meta', property='og:type'):
            og_type = soup.find('meta', property='og:type').get('content', '').lower()
            if 'video' in og_type:
                content_type = 'Video'
            elif 'article' in og_type:
                content_type = 'Artículo'
        
        # Heurísticas basadas en dominio
        if any(x in domain_lower for x in ['youtube.com', 'vimeo.com', 'video']):
            content_type = 'Video'
        elif any(x in domain_lower for x in ['blog', 'medium.com']):
            content_type = 'Artículo de Blog'
        elif any(x in domain_lower for x in ['news', 'noticia', 'bbc', 'cnn', 'elpais', 'marca']):
            content_type = 'Noticia'
        elif any(x in domain_lower for x in ['github.com', 'arxiv', 'research']):
            content_type = 'Investigación'
        elif any(x in domain_lower for x in ['x.com', 'twitter.com']):
            content_type = 'Red Social'
        
        # Verificar si el contenido extraído es de baja calidad y reintentar con Playwright
        needs_retry = False
        retry_reasons = []
        
        # Verificar resumen vacío o genérico
        if not summary or summary == "Sin resumen":
            needs_retry = True
            retry_reasons.append("sin resumen")
        elif any(x in summary.lower() for x in ['javascript is disabled', 'enable javascript', 'cookies', 'robot', 'forbidden']):
            needs_retry = True
            retry_reasons.append("página de error detectada")
        elif len(summary) < 50:
            needs_retry = True
            retry_reasons.append("resumen muy corto")
        
        # Verificar imagen generada (significa que no se encontró imagen real)
        if image_url and 'dicebear.com' in image_url:
            needs_retry = True
            retry_reasons.append("sin imagen real")
        
        # Si necesitamos reintentar y NO hemos usado Playwright aún
        if needs_retry and not use_playwright and retry_reasons:
            print(f"⚠️ Contenido incompleto detectado ({', '.join(retry_reasons)}). Reintentando con Playwright...")
            try:
                from playwright.sync_api import sync_playwright
                
                with sync_playwright() as p:
                    print(f"🔄 Abriendo navegador para {urlparse(url).netloc}...")
                    browser = p.chromium.launch(
                        headless=True,
                        args=[
                            '--disable-blink-features=AutomationControlled',
                            '--disable-dev-shm-usage',
                            '--no-sandbox'
                        ]
                    )
                    
                    context = browser.new_context(
                        user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                        viewport={'width': 1920, 'height': 1080},
                        locale='es-ES',
                        timezone_id='Europe/Madrid',
                        extra_http_headers={
                            'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
                            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
                        }
                    )
                    
                    page = context.new_page()
                    page.add_init_script("""
                        Object.defineProperty(navigator, 'webdriver', {get: () => undefined});
                        Object.defineProperty(navigator, 'plugins', {get: () => [1, 2, 3, 4, 5]});
                        Object.defineProperty(navigator, 'languages', {get: () => ['es-ES', 'es']});
                    """)
                    
                    page.goto(url, wait_until='networkidle', timeout=30000)
                    page.wait_for_timeout(3000)
                    
                    html_content = page.content()
                    browser.close()
                    
                    # Reprocesar con el nuevo HTML
                    soup_retry = BeautifulSoup(html_content, 'html.parser')
                    print(f"✅ Contenido obtenido con Playwright, reextrayendo...")
                    
                    # Re-extraer solo lo que falta
                    if "sin resumen" in retry_reasons or "resumen muy corto" in retry_reasons or "página de error" in retry_reasons:
                        # Re-extraer resumen
                        summary_retry = None
                        if soup_retry.find('meta', property='og:description'):
                            summary_retry = soup_retry.find('meta', property='og:description').get('content')
                        elif soup_retry.find('meta', attrs={'name': 'description'}):
                            summary_retry = soup_retry.find('meta', attrs={'name': 'description'}).get('content')
                        else:
                            # Buscar en article o main
                            article = soup_retry.find('article')
                            if article:
                                paragraphs = article.find_all('p')
                                if paragraphs:
                                    summary_retry = ' '.join([p.get_text().strip() for p in paragraphs[:3]])[:400]
                        
                        if summary_retry and len(summary_retry) > 50:
                            summary = summary_retry
                            print(f"✅ Resumen mejorado extraído")
                    
                    if "sin imagen real" in retry_reasons:
                        # Re-extraer imagen
                        image_retry = None
                        if soup_retry.find('meta', property='og:image'):
                            image_retry = soup_retry.find('meta', property='og:image').get('content')
                        elif soup_retry.find('meta', attrs={'name': 'twitter:image'}):
                            image_retry = soup_retry.find('meta', attrs={'name': 'twitter:image'}).get('content')
                        
                        if image_retry:
                            image_url = image_retry
                            print(f"✅ Imagen real extraída")
                    
            except Exception as e:
                print(f"⚠️ Error al reintentar con Playwright: {e}")
                # Mantener los datos originales
        
        data = {
            'title': title[:200],  # Limitar longitud
            'summary': summary[:500] if summary else "Sin resumen disponible. Visita el enlace para más información.",
            'provider': provider[:100] if provider else "Desconocido",
            'type': content_type,
            'image_url': image_url,
            'source_url': url,
            'release_date': message_date
        }
        
        return data
    
    except Exception as e:
        print(f"Error procesando URL {url}: {e}")
        return None

def send_to_backend(post_data, backend_url='http://localhost:5000/api/posts'):
    """Envía el post procesado al backend Flask"""
    import requests
    try:
        response = requests.post(backend_url, json=post_data)
        if response.status_code == 201:
            print(f"Post publicado exitosamente: {post_data['title']}")
            return True
        else:
            print(f"Error al publicar: {response.text}")
            return False
    except Exception as e:
        print(f"Error enviando al backend: {e}")
        return False

def main():
    """Función principal para ejecutar el monitor"""
    print("🤖 Iniciando monitor de Telegram...")
    
    # Obtener mensajes
    messages = get_telegram_messages()
    print(f"📨 Encontrados {len(messages)} mensajes con URLs")
    
    # Procesar cada URL
    for message in messages:
        # Convertir la fecha del mensaje a formato YYYY-MM-DD
        message_date = message.get('time', datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        if ' ' in message_date:
            message_date = message_date.split(' ')[0]  # Extraer solo la fecha
        
        for url in message['urls']:
            print(f"\n🔍 Procesando: {url}")
            post_data = process_url_content(url, message_date=message_date)
            
            if post_data:
                print(f"✅ Extraído: {post_data['title']} (Fecha: {message_date})")
                # Enviar automáticamente al backend Flask
                send_to_backend(post_data)
            else:
                print(f"❌ No se pudo procesar la URL")

if __name__ == "__main__":
    main()
