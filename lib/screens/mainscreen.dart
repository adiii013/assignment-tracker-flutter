import 'dart:math';

import 'package:assignment_tracker/year/first_year.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:animated_radial_menu/animated_radial_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text("Year"),
        centerTitle: true,
      ),
      body: RadialMenu(children: [
        RadialButton(
            icon: Icon(Icons.looks_one),
            onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>FirstYear()));
            },
            buttonColor: Colors.teal),
        RadialButton(
            icon: Icon(Icons.looks_two),
            onPress: () {},
            buttonColor: Colors.orange),
        RadialButton(
            icon: Icon(Icons.looks_3),
            onPress: () {},
            buttonColor: Colors.indigo),
        RadialButton(
            icon: Icon(Icons.looks_4),
            onPress: () {},
            buttonColor: Colors.pink),
      ]),
    );
  }
}
