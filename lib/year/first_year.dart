import 'package:assignment_tracker/sem/semone.dart';
import 'package:assignment_tracker/sem/semtwo.dart';
import 'package:flutter/material.dart';

class FirstYear extends StatefulWidget {
  FirstYear({Key? key}) : super(key: key);

  @override
  State<FirstYear> createState() => _FirstYearState();
}

class _FirstYearState extends State<FirstYear> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("First Year"),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(child: Text('Sem 1'),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(child: Text('Sem 2'),),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Tab(child: SemOne(),),
            Tab(child: SemTwo(),),
          ]
          ),
      ),
    );
  }
}