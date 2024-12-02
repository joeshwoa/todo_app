import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  String? _token;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  bool loading = false;

  final TextEditingController nameController = TextEditingController();

  Future<bool> register(String name, String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final response = await _apiService.post('/api/auth/register', {
        'username': name,
        'email': email,
        'password': password,
      });

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {

        _token = response.data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        fetchUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final response = await _apiService.post('/api/auth/login', {
        'email': email,
        'password': password,
      });

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        _token = response.data['token'];
        //print(_token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        fetchUserProfile();
        return true;
      }

      return false;
    } catch (e) {
      log(e.toString());
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUserProfile() async {
    final response = await _apiService.get('/api/auth/profile', headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      _user = User.fromJson(response.data);
      nameController.text = _user!.username;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    try {
      _token = null;
      _user = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      notifyListeners();

      return true;
    } catch (e) {
      log(e.toString());
      notifyListeners();
      return false;
    }
  }
}
