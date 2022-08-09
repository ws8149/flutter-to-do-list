import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/storage/LocalStorage.dart';

import '../../components/AppNavBar.dart';
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

  List<Todo> _todo_list = [];

  Future<void> initHomePage() async {
    LocalStorage localStorage = LocalStorage();
    await localStorage.loadTodoList();

    setState(() {
      _todo_list = localStorage.getTodoList();
    });
  }

  @override
  void initState() {
    super.initState();
    initHomePage();
  }


  void goToEditTodoPage (Todo todo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTodoPage(id: todo.id!, todoItem: todo))
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

                    Text(
                      item.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),

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
                      value: item.isComplete,
                      onChanged: (bool? val) async {
                        LocalStorage localStorage = LocalStorage();
                        await localStorage.deleteTodo(item.id!);
                        initHomePage();
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

    if (_todo_list.isNotEmpty) {
      return ListView.separated(
        padding: EdgeInsets.all(25.0),
        itemCount: _todo_list.length,
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
        itemBuilder: (_, index) {
          return Column(
            children: [
              InkWell(
                child: TodoCard(_todo_list[index]),
                onTap: () {
                  goToEditTodoPage(_todo_list[index]);
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
        child: ItemListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTodoPage(currentId: _todo_list.length))
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
