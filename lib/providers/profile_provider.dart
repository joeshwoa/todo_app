import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/providers/auth_provider.dart';
import '../services/api_service.dart';

class ProfileProvider with ChangeNotifier {

  final ApiService _apiService = ApiService();
  double uploadProgress = 0;

  bool loading = false;

  File? avatar;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      avatar = File(pickedFile.path);
      notifyListeners();
    }
  }

  /*Future<String?> uploadAvatar(File imageFile, String token) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path, filename: 'avatar.jpg'),
      });

      // Update the upload progress while uploading the image.
      final response = await _apiService.dio.post(
        '/api/profile/upload-avatar',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        onSendProgress: (int sent, int total) {
          uploadProgress = sent / total;
          notifyListeners();
        },
      );

      if (response.statusCode == 200) {
        uploadProgress = 0;
        notifyListeners();
        return response.data['avatarUrl'];
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }*/

  Future<void> updateProfile(BuildContext context, String token, String? username) async {
    try {
      loading = true;
      notifyListeners();

      final formData = FormData.fromMap({
        if(avatar != null)'avatar': await MultipartFile.fromFile(avatar!.path, filename: 'avatar.jpg'),
        if(username != null)'username': username,
      });

      // Update the upload progress while uploading the image.
      final response = await _apiService.dio.put(
        '/api/auth/profile',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        onSendProgress: (int sent, int total) {
          uploadProgress = sent / total;
          notifyListeners();
        },
      );

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        context.read<AuthProvider>().user = User.fromJson(response.data);
        uploadProgress = 0;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      loading = false;
      notifyListeners();
    }
  }
}
