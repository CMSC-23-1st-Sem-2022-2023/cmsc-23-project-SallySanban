import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/todo_model.dart';
import 'package:project_teknomo/providers/todo_provider.dart';

class TodoDialog extends StatelessWidget {
  String type;
  // int todoIndex;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  TodoDialog({
    super.key,
    required this.type,
  });

  // Method to show the title of the modal depending on the functionality
  Text title() {
    switch (type) {
      case 'Add':
        return const Text("Add new task");
      case 'Edit':
        return const Text("Edit task");
      case 'Delete':
        return const Text("Delete task");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget content(BuildContext context) {
    // Use context.read to get the last updated list of todos
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      // Edit and add will have input field in them
      default:
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Task Name",
                  ),
                ),
              ),
              Center(
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Task Description",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Flexible(
                    child: TextField(
                      controller: dayController,
                      decoration: InputDecoration(
                        hintText: "Day",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  new Flexible(
                    child: TextField(
                      controller: monthController,
                      decoration: InputDecoration(
                        hintText: "Month",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  new Flexible(
                    child: TextField(
                      controller: yearController,
                      decoration: InputDecoration(
                        hintText: "Year",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }

  TextButton buttons(BuildContext context) {
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo object to be inserted, default userID will be 1, the id will be the next id in the list
              Todo todo = Todo(
                title: titleController.text,
                description: descriptionController.text,
                status: false,
                deadline: {
                  'day': dayController.text,
                  'month': monthController.text,
                  'year': yearController.text
                },
                notifications: true,
              );

              context.read<TodoListProvider>().addTodo(todo);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              context.read<TodoListProvider>().editTodo(titleController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title(),
      content: content(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        buttons(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
