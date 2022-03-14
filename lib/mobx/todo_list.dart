
import 'package:mobx/mobx.dart';

import 'todo.dart';
part 'todo_list.g.dart';

class Todo_list = _Todo_list with _$Todo_List ;


enum VisibitiyFilter { all, pending, completed }

abstract class _Todo_list with Store {
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();
  @observable
  VisibitiyFilter filter = VisibitiyFilter.all;
  @action
  void initTodos() {
    for (var i = 0; i < 10; i++) {
      todos.add(Todo("Task - " + i.toString(),false));
    }
  }

  @action
  removeTodoAt(int index) {
    todos.removeAt(index);
  }

  @action
  addTodo(String des,bool d) {
    todos.add(Todo(des,d));
  }

  @action
  updateTodo(int index, String des, bool d) {
    todos[index].description = des;
    todos[index].done = d;
  }
}