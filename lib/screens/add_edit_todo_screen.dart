import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/auth_provider.dart';

import '../providers/todo_provider.dart';

class AddEditTodoScreen extends StatelessWidget {

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final String? id;

  AddEditTodoScreen({super.key, this.id, String? title, String? description,}) {
    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add To-Do', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Consumer<TodoProvider>(
              builder: (context, value, child) => ElevatedButton(
                onPressed: () async {
                  if(id == null) {
                    bool add = await context.read<TodoProvider>().addTask(context.read<AuthProvider>().token??'', titleController.text, descriptionController.text);
                    if(add) {
                      Navigator.pop(context);
                    }
                  } else {
                    bool update = await context.read<TodoProvider>().updateTask(context.read<AuthProvider>().token?? '', id!, titleController.text, descriptionController.text);
                    if(update) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: context.read<TodoProvider>().loading? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white,),
                ) : Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
