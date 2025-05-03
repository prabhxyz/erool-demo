import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final String _baseUrl = 'http://localhost:5000/api/auth';
  
  // Test mode flag and credentials
  final bool _testMode = true;  // Set to true for testing
  final String _testEmail = "test@example.com";
  final String _testPassword = "password123";

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_testMode && (email == _testEmail && password == _testPassword)) {
        // Create a test user for development
        _user = User(
          id: 'test-123',
          username: 'Test User',
          email: _testEmail,
          topics: ['math', 'science', 'history'],
          bookmarks: [],
          streak: 5,
          points: 100,
          badges: ['newcomer', 'quick_learner'],
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', 'test-token');
        notifyListeners();
        return;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        _user = User.fromJson(data['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Failed to login');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_testMode) {
        // Create a test user for development
        _user = User(
          id: 'test-123',
          username: username,
          email: email,
          topics: [],
          bookmarks: [],
          streak: 0,
          points: 0,
          badges: ['newcomer'],
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', 'test-token');
        notifyListeners();
        return;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 201) {
        _user = User.fromJson(data['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Failed to register');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _user = null;
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      if (_testMode) {
        // Recreate test user for development
        _user = User(
          id: 'test-123',
          username: 'Test User',
          email: _testEmail,
          topics: ['math', 'science', 'history'],
          bookmarks: [],
          streak: 5,
          points: 100,
          badges: ['newcomer', 'quick_learner'],
        );
        notifyListeners();
        return;
      }

      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/me'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _user = User.fromJson(data['user']);
          notifyListeners();
        } else {
          await logout();
        }
      } catch (e) {
        await logout();
      }
    }
  }
} 