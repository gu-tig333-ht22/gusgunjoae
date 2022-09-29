import 'package:flutter/material.dart';
import 'ToDos.dart';

class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<NewView> createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG333 To-Do"),
      ),
      body: Column(
        children: [
          _input(),
          Container(height: 30),
          _addButton(),
        ],
      ),
    );
  }

  Widget _input() {
    return Container(
      margin: const EdgeInsets.only(left: 45, right: 45, top: 150),
      child: TextField(
        controller: textController,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2)),
          labelText: "What are you planning to do?",
          labelStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _addButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
          onPressed: () {
            Navigator.pop(context,
                ToDos(todo: textController.text, checked: false, id: ''));
          },
          style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 2, color: Colors.black)),
          child: const Text(
            "+ Add To List",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          )),
    ]);
  }
}
