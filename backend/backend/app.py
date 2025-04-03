# app.py

from flask import Flask
from config import Config
from blueprints.auth import auth_bp

app = Flask(__name__)
app.config.from_object(Config)
app.debug = True  # Enable debug mode
app.use_reloader = True  

# Register the authentication blueprint with /api prefix
app.register_blueprint(auth_bp, url_prefix='/auth')

if __name__ == '__main__':
    app.run(debug=True, use_reloader=True, host='127.0.0.1', port=5000)
