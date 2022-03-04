import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:assignment_tracker/year/year.dart';
import 'package:flutter/material.dart';
import 'package:animated_radial_menu/animated_radial_menu.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

   const colorizeColors = [
  Colors.purple,
  Colors.teal,
  Colors.orange,
  Colors.green,
];

const colorizeTextStyle = TextStyle(
  fontSize: 50.0,
  
);

    return Scaffold(
      backgroundColor: Colors.white70,
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
          child: SizedBox(
            width: 300.0,
           child: AnimatedTextKit(
          animatedTexts: [
      ColorizeAnimatedText(
          'Add Assignments',
          textStyle: colorizeTextStyle,
          colors: colorizeColors,
          textAlign: TextAlign.center
      ),
      ColorizeAnimatedText(
          'Check Assignments',
          textStyle: colorizeTextStyle,
          colors: colorizeColors,
          textAlign: TextAlign.center

      ),
      ColorizeAnimatedText(
          'Delete Assignments',
          textStyle: colorizeTextStyle,
          colors: colorizeColors,
          textAlign: TextAlign.center

      ),
    ],
    isRepeatingAnimation: true,repeatForever: true,
  ),
),
        ),
          RadialMenu(children: [
            RadialButton(
                icon: Icon(Icons.looks_one),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Year(a:1)));
                },
                buttonColor: Colors.teal),
            RadialButton(
                icon: Icon(Icons.looks_two),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Year(a:2)));
                },
                buttonColor: Colors.orange),
            RadialButton(
                icon: Icon(Icons.looks_3),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Year(a:3)));
                },
                buttonColor: Colors.indigo),
            RadialButton(
                icon: Icon(Icons.looks_4),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Year(a:4)));
                },
                buttonColor: Colors.pink),
          ]),
        ],
      ),
    );
  }
}
