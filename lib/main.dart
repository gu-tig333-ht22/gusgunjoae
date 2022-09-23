import 'package:flutter/material.dart';

//Mainfunktionen returnerar MyApp
void main() {
  runApp(const MyApp());
}

bool todoValue = false; //Booleansk variabel, använda för checkbox?

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

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(todo.name),
        controlAffinity: ListTileControlAffinity.leading,
        secondary: const Icon(Icons.close),
        value: todoValue,
        onChanged: (bool? newValue) {
          onTodoChanged(todo);
        });
  }
}

//Returneras till MyApp
class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

//Skapar State
class _TodolistState extends State<Todolist> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG333: To-Do'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
          child: const Icon(Icons.add)),
    );
  }

//Pop-up ruta
  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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

//Streck över to-do texten i listan
  void _handleTodoChange(Todo todo) {
    setState(() {
      todoValue = !todoValue;
      //todo.checked = !todo.checked; // Möjligt fel här, använder den globala variabeln todoValue.
    });
  }
}
