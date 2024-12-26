import 'dart:async';
import 'package:todo/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/auth/root_page.dart';
import 'package:todo/widgets/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.auth,
  });

  final BaseAuth auth;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RootPage(
              auth: widget.auth,
            ),
          ));
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
