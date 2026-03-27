import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  // Mock users
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'fullName': 'Test Kullanıcı',
      'email': 'test@waitmate.com',
      'password': 'test1234',
      'role': 'user',
    },
    {
      'id': '2',
      'fullName': 'Yönetici',
      'email': 'admin@waitmate.com',
      'password': 'admin1234',
      'role': 'admin',
    },
  ];

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    final user = _mockUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) return null;

    final userModel = UserModel(
      id: user['id'],
      fullName: user['fullName'],
      email: user['email'],
      role: user['role'],
      token: 'mock_token_${user['id']}',
    );

    await _saveSession(userModel);
    return userModel;
  }

  Future<UserModel?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists
    final exists = _mockUsers.any((u) => u['email'] == email);
    if (exists) throw Exception('Bu e-posta adresi zaten kayıtlı.');

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      role: 'user',
      token: 'mock_token_new',
    );

    _mockUsers.add({
      'id': newUser.id,
      'fullName': newUser.fullName,
      'email': newUser.email,
      'password': password,
      'role': newUser.role,
    });

    await _saveSession(newUser);
    return newUser;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<UserModel?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, user.token ?? '');
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
