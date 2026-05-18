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
  bool _isFaceRegistered = false;
  bool _faceUploadedToServer = false;
  List<double>? _pendingFaceEmbedding;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isFaceRegistered => _isFaceRegistered;

  final AuthRepository _authRepository = AuthRepository();

  Future<bool> registerFace(List<double> faceEmbedding) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pendingFaceEmbedding = List<double>.from(faceEmbedding);
      final token = AppSession.getAccessToken();

      final response = await _authRepository.registerFaceData(
        faceEmbedding,
        authToken: token,
      );

      return response.fold(
        (error) {
          final needsAuth = error.contains('Unauthenticated') ||
              error.contains('401') ||
              error.contains('403');

          if (needsAuth) {
            _isFaceRegistered = true;
            _isLoading = false;
            notifyListeners();
            return true;
          }

          _errorMessage = error;
          _isFaceRegistered = false;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (_) {
          _isFaceRegistered = true;
          _faceUploadedToServer = true;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Face registration failed: ${e.toString()}';
      _isFaceRegistered = false;
      _faceUploadedToServer = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!_isFaceRegistered) {
      _errorMessage = 'Please register your face before creating an account.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.register({
        'name': name,
        'email': email,
        'password': password,
      });

      return await response.fold(
        (error) async {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) async {
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

          if (!_faceUploadedToServer && _pendingFaceEmbedding != null) {
            final faceResponse = await _authRepository.registerFaceData(
              _pendingFaceEmbedding!,
              authToken: token?.toString(),
            );

            final faceLinked = faceResponse.fold(
              (error) {
                _errorMessage = error;
                return false;
              },
              (_) => true,
            );

            if (!faceLinked) {
              _isFaceRegistered = false;
              _pendingFaceEmbedding = null;
              _isLoading = false;
              AppSession.setAccessToken(null);
              _currentUser = null;
              notifyListeners();
              return false;
            }
          }

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
    _isFaceRegistered = false;
    _faceUploadedToServer = false;
    _pendingFaceEmbedding = null;
    AppSession.setAccessToken(null); // Clear token on logout
    notifyListeners();
  }

  void resetFaceRegistration() {
    _isFaceRegistered = false;
    _faceUploadedToServer = false;
    _pendingFaceEmbedding = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
