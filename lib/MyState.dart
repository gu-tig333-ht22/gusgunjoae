import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ToDos.dart';

// MyState och ChaneNotifier, liknande Julkortsappen.

class MyState extends ChangeNotifier {
  List<ToDos> _list = [];
  String _filterBy = 'All';

  List<ToDos> get list => _list;
  String get filterBy => _filterBy;

  String homepage = "https://todoapp-api.apps.k8s.gu.se/todos";
  String key = "?key=d06e72e7-1201-485b-9607-adfb4d2b2864";

  MyState() {
    getupdateApiList();
  }

  void getupdateApiList() async {
    http.Response answer = await http.get(Uri.parse('$homepage$key'));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
    //print(_list); - För att felsöka och se output. Ta bort!
  }

  void updateApiList(itemlist) {
    _list.clear();
    itemlist.forEach((object) {
      _list.add(ToDos(
          todo: object["title"], checked: object["done"], id: object["id"]));
    });
    notifyListeners();
  }

  void addToDo(ToDos item) async {
    http.Response answer = await http.post(Uri.parse('$homepage$key'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": item.todo, "done": item.checked}));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
    notifyListeners();
  }

  void RemoveToDo(ToDos item) async {
    String id = item.id;
    http.Response answer = await http.delete(Uri.parse('$homepage/$id$key'));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
    notifyListeners();
  }

  void setIsDone(ToDos item) async {
    String id = item.id;
    http.Response answer = await http.put(Uri.parse('$homepage/$id$key'));
    List itemlist = jsonDecode(answer.body);
    item.checked = !item.checked;
    notifyListeners();
  }

  void setFilterBy(String filterBy) {
    this._filterBy = filterBy;
    notifyListeners();
  }
}