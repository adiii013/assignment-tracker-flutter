import 'package:assignment_tracker/sqllite/sqlliteclass.dart';
import 'package:flutter/material.dart';

class SemPage extends StatefulWidget {
  int? year;
  int? semdata;
  SemPage({required this.year, required this.semdata});
  @override
  State<SemPage> createState() => _SemPageState(year:year,semdata:semdata);
}

class _SemPageState extends State<SemPage> {
  int? year;
  int? semdata;

  _SemPageState({required this.year , required this.semdata});

  @override
  Widget build(BuildContext context) {
    return SqliteExample(year: year, semno: semdata,);
  }
}
