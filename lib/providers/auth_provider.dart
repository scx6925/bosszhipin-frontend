import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null && _user != null;

  Future<String?> register(String phone, String code, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.dio.post('/auth/register', data: {
        'phone': phone,
        'code': code,
        'password': password,
      });
      final data = res.data;
      if (data['code'] == 200) {
        _token = data['data']['token'];
        await _api.setToken(_token!);
        await _loadProfile();
        return null;
      }
      return data['message'] ?? '注册失败';
    } on Exception catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.dio.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      final data = res.data;
      if (data['code'] == 200) {
        _token = data['data']['token'];
        await _api.setToken(_token!);
        await _loadProfile();
        return null;
      }
      return data['message'] ?? '登录失败';
    } on Exception {
      return '网络错误，请稍后重试';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProfile() async {
    try {
      final res = await _api.dio.get('/user/profile');
      if (res.data['code'] == 200) {
        _user = User.fromJson(res.data['data']);
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<String?> updateProfile(Map<String, dynamic> profile) async {
    try {
      final res = await _api.dio.put('/user/profile', data: profile);
      if (res.data['code'] == 200) {
        _user = User.fromJson(res.data['data']);
        notifyListeners();
        return null;
      }
      return res.data['message'];
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await _api.clearToken();
    notifyListeners();
  }
}
