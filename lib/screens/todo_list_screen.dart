import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/add_edit_todo_screen.dart';

import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({super.key});

  bool first = true;

  @override
  Widget build(BuildContext context) {
    if(first) {
      first = false;
      context.read<TodoProvider>().fetchTasks(context.read<AuthProvider>().token??'');
    }
    return Consumer<TodoProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('To-Do List', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.person_rounded, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/add_todo');
          },
        ),
        body: context.read<TodoProvider>().loading ? Center(child: CircularProgressIndicator(color: Colors.black,)) : RefreshIndicator(
          onRefresh: () async {
            await context.read<TodoProvider>().refreshTasks(context.read<AuthProvider>().token??'');
          },
          color: Colors.black,
          backgroundColor: Colors.white,
          child: ListView.builder(
            itemCount: context.read<TodoProvider>().tasks.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditTodoScreen(id: context.read<TodoProvider>().tasks[index].id, title: context.read<TodoProvider>().tasks[index].title, description: context.read<TodoProvider>().tasks[index].description),)),
                  title: Text(
                    context.read<TodoProvider>().tasks[index].title,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    context.read<TodoProvider>().tasks[index].description,
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: context.read<TodoProvider>().loading? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white,),
                  ) : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete_rounded, color: Colors.red),
                        onPressed: () async {
                          bool delete = await context.read<TodoProvider>().deleteTask(context.read<AuthProvider>().token?? '', context.read<TodoProvider>().tasks[index].id);
                          if(delete) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Checkbox(
                        value: context.read<TodoProvider>().tasks[index].completed,
                        onChanged: (bool? value) async {
                          bool toggle = await context.read<TodoProvider>().toggleTask(context.read<AuthProvider>().token?? '', context.read<TodoProvider>().tasks[index].id);
                          if(toggle) {
                            Navigator.pop(context);
                          }
                        },
                        activeColor: Colors.black,
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
