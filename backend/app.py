from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import sqlite3
from datetime import datetime
import os
import subprocess
import sys

app = Flask(__name__)
CORS(app)
# Ruta absoluta a la base de datos en la carpeta backend
DATABASE = os.path.join(os.path.dirname(__file__), 'posts.db')
FRONTEND_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'frontend')

def get_db():
    db = sqlite3.connect(DATABASE)
    db.row_factory = sqlite3.Row
    return db

def init_db():
    with app.app_context():
        db = get_db()
        db.execute('''
            CREATE TABLE IF NOT EXISTS posts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                summary TEXT NOT NULL,
                source_url TEXT NOT NULL,
                image_url TEXT,
                release_date TEXT NOT NULL,
                provider TEXT,
                type TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        db.commit()

@app.route('/api/posts', methods=['GET', 'POST'])
def posts():
    if request.method == 'POST':
        data = request.json
        required_fields = ['title', 'summary', 'source_url', 'release_date']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400
        try:
            db = get_db()
            
            # Verificar si ya existe un post con la misma source_url
            existing = db.execute('SELECT id FROM posts WHERE source_url = ?', (data['source_url'],)).fetchone()
            if existing:
                return jsonify({'id': existing['id'], 'message': 'Post already exists (duplicate skipped)'}), 200
            
            # Insertar nuevo post si no existe
            cursor = db.execute('''
                INSERT INTO posts (title, summary, source_url, image_url, release_date, provider, type)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', (data['title'], data['summary'], data['source_url'], data.get('image_url'), 
                  data['release_date'], data.get('provider'), data.get('type')))
            db.commit()
            return jsonify({'id': cursor.lastrowid, 'message': 'Post created successfully'}), 201
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    else:
        try:
            db = get_db()
            posts = db.execute('SELECT * FROM posts ORDER BY created_at DESC').fetchall()
            return jsonify([dict(post) for post in posts])
        except Exception as e:
            return jsonify({'error': str(e)}), 500

@app.route('/api/posts/<int:post_id>', methods=['GET'])
def get_post(post_id):
    try:
        db = get_db()
        post = db.execute('SELECT * FROM posts WHERE id = ?', (post_id,)).fetchone()
        if post:
            return jsonify(dict(post))
        return jsonify({'error': 'Post not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/refresh', methods=['POST'])
def refresh_telegram():
    """Ejecuta el monitor de Telegram para buscar nuevos posts"""
    try:
        # Ruta al script del monitor
        project_root = os.path.dirname(os.path.dirname(__file__))
        monitor_script = os.path.join(project_root, 'mcp_integration', 'telegram_mcp.py')
        
        # Ejecutar el monitor en un proceso separado con encoding UTF-8
        env = os.environ.copy()
        env['PYTHONIOENCODING'] = 'utf-8'
        
        result = subprocess.run(
            [sys.executable, monitor_script],
            cwd=project_root,
            capture_output=True,
            text=True,
            timeout=120,  # Timeout de 2 minutos
            env=env
        )
        
        # Contar posts después de la actualización
        db = get_db()
        total_posts = db.execute('SELECT COUNT(*) as count FROM posts').fetchone()['count']
        
        return jsonify({
            'success': True,
            'message': 'Monitor ejecutado correctamente',
            'total_posts': total_posts,
            'output': result.stdout[-500:] if result.stdout else '',  # Últimas 500 caracteres
            'errors': result.stderr[-500:] if result.stderr else ''
        }), 200
        
    except subprocess.TimeoutExpired:
        return jsonify({
            'success': False,
            'error': 'El monitor tardó demasiado (timeout 2 minutos)'
        }), 408
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/')
def index():
    """Sirve el frontend index.html"""
    return send_from_directory(FRONTEND_DIR, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    """Sirve archivos estáticos del frontend"""
    return send_from_directory(FRONTEND_DIR, path)

if __name__ == '__main__':
    init_db()
    app.run(debug=True, port=5000)
