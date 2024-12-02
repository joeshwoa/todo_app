import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/profile_provider.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: context.read<AuthProvider>().user == null ? Center(child: CircularProgressIndicator(color: Colors.black,)) : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: context.read<ProfileProvider>().pickAvatar,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: context.read<ProfileProvider>().avatar != null ? FileImage(context.read<ProfileProvider>().avatar!) : (context.read<AuthProvider>().user == null || context.read<AuthProvider>().user!.avatarUrl.isEmpty ? (AssetImage('assets/default_avatar.png') as ImageProvider) : NetworkImage(context.read<AuthProvider>().user!.avatarUrl)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: context.read<AuthProvider>().nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await context.read<ProfileProvider>().updateProfile(context, context.read<AuthProvider>().token??'', context.read<AuthProvider>().nameController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: context.read<ProfileProvider>().loading? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white,),
                ) : Text('Update Profile'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool logout = await context.read<AuthProvider>().logout();
                  if(logout) {
                    if(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.redAccent,
                ),
                child: Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
