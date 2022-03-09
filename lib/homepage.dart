import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:mobx/mobx.dart';

import 'mobx/todo_list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _listViewTodoState();
}

class _listViewTodoState extends State<TodoScreen> {
  @observable

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
      body: Center(child: _listViewBuilder()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addDialog(),
        tooltip: 'Add more tasks',
        child: const Icon(Icons.add),
      ),
    );
  }



  Widget _listViewBuilder() {
    return Observer(
        builder: (context) => ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index)
            {
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
                  todo_list!.removeTodoAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo_list!.todos[index].description} dismissed')));
                },
                child: InkWell(
                  child: _todoItemsBuilder(index),
                ),
              );
            },

          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
          itemCount: todo_list!.todos.length,
        ));
  }

  //----TO DO ITEMS----//

  Widget _todoItemsBuilder(int index) {
    return ListTile(
      leading: const Icon(Icons.assignment_turned_in_outlined),
      title: Text(
        todo_list!.todos[index].description,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        todo_list!.todos[index].description,
      ),
      trailing: const Icon(Icons.navigate_next),
      //onLongPress: () => delDialog(index),
      onTap:  () => delDialog(index),

    );
  }



  final taskController = TextEditingController();

  addDialog() async {
    taskController.clear();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
                    controller: taskController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: 'Task Description: ',
                        hintText: 'eg. Brush your teeth'))),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.pop(context, 'Yes'),
              if (taskController.text.isNotEmpty)
                todo_list!.addTodo(taskController.text)
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  //----DELETE DIALOG----//

  bool delDialog(int index) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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