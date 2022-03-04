import 'package:assignment_tracker/sem/sempage.dart';
import 'package:flutter/material.dart';

class Year extends StatelessWidget {
  int? a;
  Year({this.a});

  String yearName(int? a) {
    if (a == 1)
      return "First Year";
    else if (a == 2)
      return "Second Year";
    else if (a == 3) return "Third Year";
    return "Fourth Year";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(yearName(a)),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text(
                    'Sem 1',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text(
                    "Sem 2",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Tab(
            child: SemPage(year: a, semdata: 1),
          ),
          Tab(
            child: SemPage(year: a, semdata: 2),
          ),
        ]),
      ),
    );
  }
}
