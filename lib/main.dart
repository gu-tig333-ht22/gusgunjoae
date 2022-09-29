import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'NewView.dart';
import 'ToDos.dart';
import 'MyState.dart';

void main() {
  var state = MyState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => state,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-do List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeView(),
    );
  }
}

//Förstasidan
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG333 To-Do"),
        actions: [
          Consumer<MyState>(
            builder: (context, state, child) => Row(
              children: [
                Text(
                  state.filterBy,
                  style: const TextStyle(fontSize: 18),
                ),
//Knapp för filtrering. Från julkortsappen
                PopupMenuButton(
                  onSelected: (value) =>
                      Provider.of<MyState>(context, listen: false)
                          .setFilterBy(value as String),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'All', child: Text("All")),
                    const PopupMenuItem(value: 'Done', child: Text("Done")),
                    const PopupMenuItem(
                        value: 'Not Done', child: Text("Not Done")),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      body: Consumer<MyState>(builder: (context, state, child) {
        return ToDoList(_filterList(state.list, state.filterBy));
      }),
// FloatingActionButton - knapp som leder till ny vy (newview) där man kan lägga till nya To-Dos
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var newItem = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewView()));
          if (newItem != null && newItem.todo != "") {
            Provider.of<MyState>(context, listen: false).addToDo(newItem);
          }
        },
      ),
    );
  }
}

//ToDoList - Lista av ToDos, tar in dem från ToDoItems
class ToDoList extends StatelessWidget {
  final List<ToDos> list;
  const ToDoList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      children: list.map((item) => ToDoItems(context, item)).toList(),
    );
  }

  // ToDoItems - Represenationen av ToDoS i ToDoListan. Checkbox/Linethrough/Text/Tabort-knapp
  Widget ToDoItems(context, item) {
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            value: item.checked,
            onChanged: (value) {
              Provider.of<MyState>(context, listen: false).setIsDone(item);
            },
          ),
          title: Text(
            item.todo,
            style: item.checked
                ? const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black)
                : const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_sharp, size: 30),
            onPressed: () {
              Provider.of<MyState>(context, listen: false).RemoveToDo(item);
            },
          ),
        ),
        const Divider(height: 15, thickness: 2),
      ],
    );
  }
}

//Filtreringsmeny.
List<ToDos> _filterList(list, filterBy) {
  if (filterBy == 'All') {
    return list;
  }
  if (filterBy == 'Done') {
    return list.where((item) => item.checked == true).toList();
  }
  if (filterBy == 'Not Done') {
    return list.where((item) => item.checked == false).toList();
  }
  return list;
}
