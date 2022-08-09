import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AppNavBar.dart';
import '../../helpers/DateTimeHelpers.dart';
import '../../models/AppDate.dart';
import '../../models/Todo.dart';
import 'AddTodoPage.dart';
import 'EditTodoPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool? value = false;

  List<Todo> itemList = [];

  Future<void> initHomePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsTodos = prefs.getString('TODO_ITEMS') ?? '';

    List<Todo> todoList = [];

    List<dynamic> jsonList = [];

    if (prefsTodos != '') {
      jsonList = jsonDecode(prefsTodos);
    }

    for (var json in jsonList) {
      Todo todo = Todo.fromJson(json);

      todoList.add(todo);
    }

    print("todos retrieved: ");
    print(todoList.toString());

    setState(() {
      itemList = todoList;
    });
  }

  @override
  void initState() {
    super.initState();
    initHomePage();
  }


  void goToEditTodoPage (dynamic item) {
    print('Going to add todo page..');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTodoPage(id: item['id'], todoItem: item))
    );
  }

  Widget TodoCard (Todo item) {
    const GREY_TEXT = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey);
    AppDate start_app_date = item.startAppDate!;
    AppDate end_app_date = item.endAppDate!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Color(0xffCED4DA)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: (
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Text(item.title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                    const SizedBox(height: 10),

                    Container(
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Date', style: GREY_TEXT),
                              const SizedBox(height: 5),
                              Text(start_app_date.displayDate!, style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('End Date', style: GREY_TEXT),
                              const SizedBox(height: 5),
                              Text(end_app_date.displayDate!, style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time Left', style: GREY_TEXT),
                              const SizedBox(height: 5),
                              Text(item.timeLeft!, style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 8),
            color: Color(0xffccc4b7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Status', style: GREY_TEXT),
                    const SizedBox(width: 10),
                    Text('Incomplete', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  ],
                ),
                Row(
                  children: [
                    Text('Tick if completed', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: this.value,
                      onChanged: (bool? val) async {
                        setState(() {
                          this.value = val;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget ItemListWidget () {

    if (itemList.isNotEmpty) {
      return ListView.separated(
        itemCount: itemList.length,
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
        itemBuilder: (_, index) {
          return Column(
            children: [
              InkWell(
                child: TodoCard(itemList[index]),
                onTap: () {
                  goToEditTodoPage(itemList[index]);
                },
              ),
            ],
          );
        },
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: Text('To-do List is empty at the moment.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        label: 'To-Do List',
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            child: ItemListWidget()
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          int currentId = 1;
          if (itemList.length > 0) {
            currentId = itemList.length - 1;
          }

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTodoPage(current_id: currentId))
          );
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepOrange,
      ), // T
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,// his trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
