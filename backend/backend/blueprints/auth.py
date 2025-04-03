# blueprints/auth.py

from flask import Blueprint, request, jsonify
import hashlib
from database import get_connection

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/signup', methods=['POST'])
def signup():
    print("Received signup request")
    data = request.get_json()
    print("Request data:", data)
    
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    age = data.get('age')
    
    print(f"Extracted fields - name: {name}, email: {email}, password: {'*' * len(password) if password else None}, age: {age}")

    if not name:
        return jsonify({'message': 'Missing name field'}), 400
    if not email:
        return jsonify({'message': 'Missing email field'}), 400
    if not password:
        return jsonify({'message': 'Missing password field'}), 400
    if age is None:
        return jsonify({'message': 'Missing age field'}), 400

    # Check if the user already exists
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
            existing_user = cursor.fetchone()
    finally:
        connection.close()

    if existing_user:
        return jsonify({'message': 'User already exists'}), 400

    # Hash the password (for demo purposes; consider using a stronger hash function like bcrypt in production)
    password_hash = hashlib.sha256(password.encode()).hexdigest()

    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            sql = "INSERT INTO users (username, email, password, age) VALUES (%s, %s, %s, %s)"
            cursor.execute(sql, (name, email, password_hash, age))
        connection.commit()
    finally:
        connection.close()

    return jsonify({'message': 'User created successfully'}), 201

@auth_bp.route('/signin', methods=['POST'])
def signin():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Missing email or password'}), 400

    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
            user = cursor.fetchone()
    finally:
        connection.close()

    if not user:
        return jsonify({'message': 'Invalid credentials'}), 401

    password_hash = hashlib.sha256(password.encode()).hexdigest()
    if password_hash != user['password']:
        return jsonify({'message': 'Invalid credentials'}), 401

    return jsonify({'message': 'Signed in successfully'}), 200
