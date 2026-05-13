import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import 'package:states_app/core/preferences/user_preferences.dart';

// Defined User class here to avoid dependency issues with db_service.dart
class User {
  final String? id; // Changed to String? to support UUID from API
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  final AuthRepository _authRepository = AuthRepository();

  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.register({
        'name': name,
        'email': email,
        'password': password,
      });

      return response.fold(
        (error) {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) {
          final token = data['token'];
          final userData = data['user'];

          if (token != null) {
            AppSession.setAccessToken(token);
          }

          _currentUser = User(
            id: userData['userId'],
            name: userData['name'] ?? name,
            email: userData['email'] ?? email,
            password: password,
          );

          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to create user: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login({
        'email': email,
        'password': password,
      });

      return response.fold(
        (error) {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) {
          final token = data['token'];
          final userData = data['user'];

          if (token != null) {
            AppSession.setAccessToken(token);
          }

          _currentUser = User(
            id: userData['userId'],
            name: userData['name'] ?? 'User',
            email: userData['email'] ?? email,
            password: password,
          );

          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    AppSession.setAccessToken(null); // Clear token on logout
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
