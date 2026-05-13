import 'package:flutter/material.dart';
import 'package:states_app/features/home/home_repository/home_repository.dart';

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class HomeProvider with ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();

  UserProfile? _userProfile;
  List<UserProfile> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get userProfile => _userProfile;
  List<UserProfile> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _homeRepository.getProfile();

    result.fold(
      (error) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        if (data['user'] != null) {
          _userProfile = UserProfile.fromJson(data['user']);
        }
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _homeRepository.getAllUsers();

    result.fold(
      (error) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        if (data['users'] != null) {
          _users = (data['users'] as List)
              .map((userJson) => UserProfile.fromJson(userJson))
              .toList();
        }
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
