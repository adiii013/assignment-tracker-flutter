import 'package:assignment_tracker/sem/sempage.dart';
import 'package:flutter/material.dart';

class Year extends StatelessWidget {
  int? a;
  Year({this.a});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(a.toString()),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text('Sem 1'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text("Sem 2"),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Tab(
            child: SemPage(year:a,semdata:1),
          ),
          Tab(
            child: SemPage(year: a,semdata: 2),
          ),
        ]),
      ),
    );
  }
}
