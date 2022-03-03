import 'package:flutter/material.dart';

class SemTwo extends StatefulWidget {
  SemTwo({Key? key}) : super(key: key);

  @override
  State<SemTwo> createState() => _SemTwoState();
}

class _SemTwoState extends State<SemTwo> {
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