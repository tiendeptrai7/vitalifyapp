
part of 'todo_list.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Todo_List on _Todo_list, Store {
  final _$todosAtom = Atom(name: '_Todo_List.todos');

  @override
  ObservableList<Todo> get todos {
    _$todosAtom.reportRead();
    return super.todos;
  }

  @override
  set todos(ObservableList<Todo> value) {
    _$todosAtom.reportWrite(value, super.todos, () {
      super.todos = value;
    });
  }

  final _$filterAtom = Atom(name: '_Todo_List.filter');

  @override
  VisibitiyFilter get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(VisibitiyFilter value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$_Todo_ListActionController = ActionController(name: '_Todo_List');

  @override
  void initTodos() {
    final _$actionInfo =
    _$_Todo_ListActionController.startAction(name: '_Todo_List.initTodos');
    try {
      return super.initTodos();
    } finally {
      _$_Todo_ListActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeTodoAt(int index) {
    final _$actionInfo = _$_Todo_ListActionController.startAction(
        name: '_Todo_List.removeTodoAt');
    try {
      return super.removeTodoAt(index);
    } finally {
      _$_Todo_ListActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addTodo(String des) {
    final _$actionInfo =
    _$_Todo_ListActionController.startAction(name: '_Todo_List.addTodo');
    try {
      return super.addTodo(des);
    } finally {
      _$_Todo_ListActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
todos: ${todos},
filter: ${filter}
    ''';
  }
}