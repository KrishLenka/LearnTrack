import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String uid;
  final String email;
  final String? name;

  User({required this.uid, required this.email, this.name});
}

class AuthService {
  String get baseUrl {
    // When running on iOS Simulator, use host.docker.internal
    if (Platform.isIOS) {
      return 'http://127.0.0.1:5000/';
    }
    // When running on Android Emulator, use 10.0.2.2
    else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }
    // For web or desktop platforms
    else {
      return 'http://127.0.0.1:5000/api';
    }
  }
  
  User? _currentUser;
  
  // Get the current authenticated user
  User? get currentUser => _currentUser;
  
  // Stream to listen to auth state changes
  final ValueNotifier<User?> _authStateChanges = ValueNotifier<User?>(null);
  ValueNotifier<User?> get authStateChanges => _authStateChanges;

  // Initialize and check for stored token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      try {
        // Validate token with backend
        final response = await http.get(
          Uri.parse('$baseUrl/auth/validate'),
          headers: {'Authorization': 'Bearer $token'},
        );
        
        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          _currentUser = User(
            uid: userData['uid'],
            email: userData['email'],
            name: userData['name'],
          );
          _authStateChanges.value = _currentUser;
        } else {
          // Token invalid, clear it
          await prefs.remove('auth_token');
        }
      } catch (e) {
        // Error occurred, clear token
        await prefs.remove('auth_token');
      }
    }
  }

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'age': age,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // Store token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        // Set current user
        _currentUser = User(
          uid: data['uid'],
          email: email,
          name: name,
        );
        _authStateChanges.value = _currentUser;
        
        return _currentUser;
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'An error occurred during sign up.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // Store token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        // Set current user
        _currentUser = User(
          uid: data['uid'],
          email: email,
          name: data['name'],
        );
        _authStateChanges.value = _currentUser;
        
        return _currentUser;
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'An error occurred during sign in.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _currentUser = null;
      _authStateChanges.value = null;
    } catch (e) {
      throw 'An error occurred while signing out.';
    }
  }

  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      
      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'An error occurred while sending password reset email.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      if (_currentUser == null) return null;
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) return null;
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/${_currentUser!.uid}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'An error occurred while getting user data.';
      }
    } catch (e) {
      throw 'Error getting user data: $e';
    }
  }
}
