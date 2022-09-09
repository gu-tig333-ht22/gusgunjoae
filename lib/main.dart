//Första inlämningen bla bla
import 'package:flutter/material.dart';

//Mainfunktionen returnerar MyApp
void main() {
  runApp(const MyApp());
}

//"Bas" för applikationen.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application. Ger titel, temafärg och returnerar Todolist-widgeten.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 To-Do',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Todolist(),
    );
  }
}

//To-Do defineras (vad det ska innehålla)
class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

//To Do Item, varje enskild att-göra sak
class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        secondary: const Icon(Icons.close),
        title: Text(todo.name, style: _getTextStyle(todo.checked)),
        value: false,
        onChanged: (bool? newValue) {
          //setState(() {
          // = newValue;
        });
  }
}

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => new _TodolistState();
}

//Skapar
class _TodolistState extends State<Todolist> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('TIG333: To-Do'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Lägg Till',
          child: Icon(Icons.add)),
    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lägg till saker att göra'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Skriv Här'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Lägg Till'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }
}
