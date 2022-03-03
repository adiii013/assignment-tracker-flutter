import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoItem {
  final int? id;
  final String content;
  final bool isDone;
  final DateTime createdAt;
  final int? year;
  final int? semno;

  TodoItem(
      {this.id,
      required this.content,
      this.isDone = false,
      required this.createdAt,
      required this.year,
      required this.semno});

  TodoItem.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        content = map['content'] as String,
        isDone = map['isDone'] == 1,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        year = map['year'] as int,
        semno = map['semno'] as int;

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'content': content,
        'isDone': isDone ? 1 : 0,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'year': year,
        'semno': semno
      };
}

class SqliteExample extends StatefulWidget {
  int? year;
  int? semno;
  SqliteExample({required this.year, required this.semno});
  @override
  _SqliteExampleState createState() =>
      _SqliteExampleState(yeardata: year, semnodata: semno);
}

class _SqliteExampleState extends State<SqliteExample> {
  int? yeardata;
  int? semnodata;
  _SqliteExampleState({required this.yeardata, required this.semnodata});

  static const kDbFileName = 'sqflite_x.db';
  static const kDbTableName = 'asi';
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  late Database _db;
  List<TodoItem> _todos = [];

  Future<void> _initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, kDbFileName);
    this._db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
        CREATE TABLE $kDbTableName(
          id INTEGER PRIMARY KEY, 
          isDone BIT NOT NULL,
          content TEXT,
          createdAt INT,
          year INT,
          semno INT
          )
        ''',
        );
      },
    );
  }

  Future<void> _getTodoItems() async {
    final List<Map<String, dynamic>> jsons =
        await this._db.rawQuery('SELECT * FROM $kDbTableName WHERE (year==${yeardata} AND semno==${semnodata})');
    print('${jsons.length} rows retrieved from db!');
    this._todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
  }

  Future<void> _addTodoItem(TodoItem todo) async {
    await this._db.transaction(
      (Transaction txn) async {
        final int id = await txn.rawInsert(
          '''
          INSERT INTO $kDbTableName
            (content, isDone, createdAt,year,semno)
          VALUES
            (
              "${todo.content}",
              ${todo.isDone ? 1 : 0}, 
              ${todo.createdAt.millisecondsSinceEpoch},
              ${todo.year},
              ${todo.semno}
            )''',
        );
        print('Inserted todo item with id=$id.');
      },
    );
  }

  // Updates records in the db table.
  Future<void> _toggleTodoItem(TodoItem todo) async {
    final int count = await this._db.rawUpdate(
      '''
      UPDATE $kDbTableName
      SET isDone = ?
      WHERE id = ?''',
      [if (todo.isDone) 0 else 1, todo.id],
    );
    print('Updated $count records in db.');
  }

  Future<void> _deleteTodoItem(TodoItem todo) async {
    final count = await this._db.rawDelete(
      '''
        DELETE FROM $kDbTableName
        WHERE id = ${todo.id}
      ''',
    );
    print('Updated $count records in db.');
  }

  Future<bool> _asyncInit() async {
    await _memoizer.runOnce(() async {
      await _initDb();
      await _getTodoItems();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: ListView(
            children: this._todos.map(_itemToListTile).toList(),
          ),
          floatingActionButton: _buildFloatingActionButton(),
        );
      },
    );
  }

  Future<void> _updateUI() async {
    await _getTodoItems();
    setState(() {});
  }

  ListTile _itemToListTile(TodoItem todo) => ListTile(
        title: Text(
          todo.content,
          style: TextStyle(
            fontStyle: todo.isDone ? FontStyle.italic : null,
            color: todo.isDone ? Colors.grey : null,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('id=${todo.id}\ncreated at ${todo.createdAt}'),
        isThreeLine: true,
        leading: IconButton(
          icon: Icon(
            todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          ),
          onPressed: () async {
            await _toggleTodoItem(todo);
            _updateUI();
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await _deleteTodoItem(todo);
            _updateUI();
          },
        ),
      );

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await _addTodoItem(
          TodoItem(
              content: "Dfvdsvfdsv",
              createdAt: DateTime.now(),
              year: yeardata,
              semno: semnodata),
        );
        _updateUI();
      },
      child: const Icon(Icons.add),
    );
  }
}
