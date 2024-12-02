class todos {
  List<todo> tasks;
  int total;
  int skip;
  int limit;

  todos({
    required this.tasks,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory todos.fromJson (json) {
    List<todo> tasks = [];
    for (var i = 0; i < json['todos'].length; i++) {
      final Map task = json['todos'][i];
      final todo todoTask = todo.fromJson(task);
      tasks.add(todoTask);
    }
    return todos(
      tasks: json['todos'].map( (Map task) => todo.fromJson(task) ),  // List<Map> e => anther List<todo> e
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}

class todo {
  int id;
  String task;
  bool completed;
  int userId;

  todo({
    required this.id,
    required this.task,
    required this.completed,
    required this.userId,
  });

  factory todo.fromJson(json) {
    return todo(
      id: json['id'],
      task: json['task'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

}


/*
{
    "todos": [
        {
            "id": 2,
            "todo": "Memorize a poem",
            "completed": true,
            "userId": 13
        },
        {
            "id": 21,
            "todo": "Create a compost pile",
            "completed": false,
            "userId": 13
        },
        {
            "id": 76,
            "todo": "Make homemade ice cream",
            "completed": false,
            "userId": 13
        },
        {
            "id": 82,
            "todo": "Fix something that's broken in house",
            "completed": false,
            "userId": 13
        },
        {
            "id": 86,
            "todo": "Learn the periodic table",
            "completed": false,
            "userId": 13
        },
        {
            "id": 183,
            "todo": "Start a nature journal",
            "completed": true,
            "userId": 13
        }
    ],
    "total": 6,
    "skip": 0,
    "limit": 6
}
 */