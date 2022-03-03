import 'package:flutter/material.dart';

class SemOne extends StatefulWidget {
  SemOne({Key? key}) : super(key: key);

  @override
  State<SemOne> createState() => _SemOneState();
}

class _SemOneState extends State<SemOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('sem one'),
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){},),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}