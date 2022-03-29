import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mobx/mobx.dart';
import 'package:vitalifyapp/store/todo_list.dart';


class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
  @observable
  final taskController = TextEditingController();

  Todo_list? todo_list;

  @override
  Widget build(BuildContext context) {
    todo_list = Todo_list();
    todo_list?.initTodos();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TodoScreen'),
      ),
      body: Center(child: _listView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addDialog(),
        tooltip: 'Add more tasks',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _listView() {
    return Observer(
        builder: (context) =>
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int i) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  // 8
                  background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete_forever,
                          color: Colors.white, size: 50.0)),
                  onDismissed: (direction) {
                    todo_list!.removeTodoAt(i);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${todo_list!.todos[i].description} dismissed')));
                  },
                  child: InkWell(
                    child: _todoItems(i),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
              itemCount: todo_list!.todos.length,
            ));
  }

  Widget _todoItems(int i) {
    return Observer(builder: (BuildContext context) {
      if (todo_list!.todos[i].done == true) {
        return ListTile(
          leading: const Icon(Icons.done),
          title: Text(
            todo_list!.todos[i].description,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.lightBlue),
          ),
          subtitle: Text(
            todo_list!.todos[i].description,
          ),
          trailing:
          const Icon(Icons.navigate_next),
          onLongPress: () => deleteDialog(i),
          onTap:  () => updateDialog(
              done: todo_list!.todos[i].done,
              des: todo_list!.todos[i].description,
              index: i),
        );
      } else {
        return ListTile(
          leading: const Icon(Icons.assignment_turned_in_outlined),
          title: Text(
            todo_list!.todos[i].description,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            todo_list!.todos[i].description,
          ),
          trailing:
          const Icon(Icons.navigate_next),
          onLongPress: () => addDialog(),
          onTap:  () => updateDialog(
              done: todo_list!.todos[i].done,
              des: todo_list!.todos[i].description,
              index: i),
        );
      }
    },

    );

  }

  addDialog() async {
    bool status = false;
    taskController.clear();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
        StatefulBuilder(
            builder: (context,setState ) =>
                AlertDialog(
                  title: const Text('Add Dialog'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: taskController,
                        decoration: const InputDecoration(
                            labelText: 'Add des todo'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FlutterSwitch(
                        value: status,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status = val;
                          });
                        },
                      ),

                    ],
                  ),
                  actions: [
                    const SizedBox(
                      height: 5,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel')),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, 'Yes');
                          if (taskController.text.isNotEmpty) {
                            todo_list!.addTodo(
                          taskController.text, status);
                          }
                        },
                        child: const Text('Confirm'))
                  ],
                )
        )
    );
  }
  final desTextController = TextEditingController();
  @action

  updateDialog(
      {bool done = false, required String des , required int index }) {
    desTextController.text = des;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: const SizedBox(
            width: double.infinity,
            child:  Text(
               "Update",
              textAlign: TextAlign.center,
            )),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        controller: desTextController,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Task Description: ',
                            hintText: 'eg. Brush your teeth')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlutterSwitch(
                          value: done,
                          showOnOff: true,
                          onToggle: (value) => {
                            setState(() {
                              done = value;
                            })
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel')),
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context, 'Yes');
                if (desTextController.text.isNotEmpty) {
                  todo_list!.updateTodo(index, desTextController.text, done);
                }
              },
              child: const Text('Confirm'))
        ],
      ),
    );
  }


  bool deleteDialog(int index) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text(
              'Delete item!!',
              style: TextStyle(color: Colors.blueAccent),
            ),
            content: const Text('Do you want to delete this item?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                {Navigator.pop(context, 'Yes'), todo_list!.removeTodoAt(index)},
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    return true;
  }
}
