import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://localhost:5000/api/auth';

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = User.fromJson(data['user']);
        await _storage.write(key: 'token', value: data['token']);
        notifyListeners();
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
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
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _user = User.fromJson(data['user']);
        await _storage.write(key: 'token', value: data['token']);
        notifyListeners();
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _user = null;
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      // Implement token validation and user data retrieval
      // This would typically involve a request to validate the token
      // and get the current user's data
    }
  }
} 