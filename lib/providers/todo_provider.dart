import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TodoProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  bool loading = true;

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks(String token) async {

    final response = await _apiService.get('/api/todos/all', headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      _tasks = (response.data as List).map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> refreshTasks(String token) async {

    _tasks.clear();
    loading = false;
    notifyListeners();

    final response = await _apiService.get('/api/todos/all', headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      _tasks = (response.data as List).map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> addTask(String token, String title, String description) async {
    try {
      loading = true;
      notifyListeners();

      final response = await _apiService.post('/api/todos/add', {
        'title': title,
        'description': description,
      }, headers: {
        'Authorization': 'Bearer $token',
      });

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        _tasks.add(Task.fromJson(response.data));
        notifyListeners();
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

  Future<bool> updateTask(String token, String id, String title, String description) async {
    try {
      loading = true;
      notifyListeners();

      final response = await _apiService.put('/api/todos/update', {
        'taskId': id,
        'title': title,
        'description': description,
      }, headers: {
        'Authorization': 'Bearer $token',
      });

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        int index = _tasks.indexWhere((element) => element.id == id,);
        _tasks[index] = Task.fromJson(response.data);
        notifyListeners();
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

  Future<bool> toggleTask(String token, String id) async {
    try {
      loading = true;
      notifyListeners();

      final response = await _apiService.put('/api/todos/toggle/$id', {}, headers: {
        'Authorization': 'Bearer $token',
      });

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        int index = _tasks.indexWhere((element) => element.id == id,);
        _tasks[index] = Task.fromJson(response.data);
        notifyListeners();
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

  Future<bool> deleteTask(String token, String id) async {
    try {
      loading = true;
      notifyListeners();

      final response = await _apiService.delete('/api/todos/delete/$id', headers: {
        'Authorization': 'Bearer $token',
      });

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
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
}
