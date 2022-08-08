import 'package:flutter/material.dart';

import '../../components/AppNavBar.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  bool? value = false;


  void _addTodoItem() {
    setState(() {
      _counter++;
    });
  }

  void goToEditPage (dynamic item) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EditTodoPage(todoItem: item),
    // );
  }

  Widget TodoCard () {
    const GREY_TEXT = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey);

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

                    Text('Automated Testing Script', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Date', style: GREY_TEXT),
                            const SizedBox(height: 5),
                            Text('21 Oct 2019', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Date', style: GREY_TEXT),
                            const SizedBox(height: 5),
                            Text('21 Oct 2019', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time Left', style: GREY_TEXT),
                            const SizedBox(height: 5),
                            Text('23 hrs 22 min', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
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
                      onChanged: (bool? val) {
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
    List<dynamic> itemList = [{"id": 1, "name": "a"}, {"id": 2, "name": "a"}];

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
                child: TodoCard(),
                onTap: () {
                  goToEditPage(itemList[index]);
                },
              ),
            ],
          );
        },
      );
    } else {
      return Container();
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
        onPressed: _addTodoItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepOrange,
      ), // T
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,// his trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
