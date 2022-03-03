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
  final int sem;

  TodoItem({
    this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    required this.sem,
  });

  TodoItem.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        content = map['content'] as String,
        isDone = map['isDone'] == 1,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int,
            ),
        sem = map['map'] as int
;

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'content': content,
        'isDone': isDone ? 1 : 0,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'sem':sem
      };
}

class SqliteExample extends StatefulWidget {
  const SqliteExample({Key? key}) : super(key: key);

  @override
  _SqliteExampleState createState() => _SqliteExampleState();
}

class _SqliteExampleState extends State<SqliteExample> {
  static const kDbFileName = 'sqflite_ex.db';
  static const kDbTableName = 'example_tbl';
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  late Database _db;
  List<TodoItem> _todos = [];

  // Opens a db local file. Creates the db table if it's not yet created.
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
          sem INT)
        ''',
        );
      },
    );
  }

  // Retrieves rows from the db table.
  Future<void> _getTodoItems() async {
    final List<Map<String, dynamic>> jsons =
        await this._db.rawQuery('SELECT * FROM $kDbTableName');
    print('${jsons.length} rows retrieved from db!');
    this._todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
  }

  // Inserts records to the db table.
  // Note we don't need to explicitly set the primary key (id), it'll auto
  // increment.
  Future<void> _addTodoItem(TodoItem todo) async {
    await this._db.transaction(
      (Transaction txn) async {
        final int id = await txn.rawInsert(
          '''
          INSERT INTO $kDbTableName
            (content, isDone, createdAt)
          VALUES
            (
              "${todo.content}",
              ${todo.isDone ? 1 : 0}, 
              ${todo.createdAt.millisecondsSinceEpoch},
              ${todo.sem}
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

  // Deletes records in the db table.
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
            content: "dfvsd",
            createdAt: DateTime.now(),
            sem: 1
          ),
        );
        _updateUI();
      },
      child: const Icon(Icons.add),
    );
  }
}
