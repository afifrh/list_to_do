import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/widgets/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.deepPurpleAccent,
          ),
          Center(
            child: Container(
              height: 250,
              width: 150,
              child: Image.asset("assets/images/notesicon.png"),
            ),
          )
        ],
      ),
    );
  }
}
