import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:todo/widgets/homepage.dart';
import 'package:todo/services/auth.dart';

class RootPage extends StatefulWidget {
  const RootPage({
    super.key,
    required this.auth,
  });

  final BaseAuth auth;

  @override
  State<RootPage> createState() => _RootPageState();
}

enum AuthStatus {
  signedIn,
  notSignedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final user = await widget.auth.currentUser();
    if (!mounted) return;

    setState(() {
      if (user != null) {
        _userId = user.uid;
        _authStatus = AuthStatus.signedIn;
      } else {
        _authStatus = AuthStatus.notSignedIn;
      }
    });
  }

  Future<void> _signedIn() async {
    final user = await widget.auth.currentUser();
    if (!mounted) return;

    setState(() {
      _authStatus = AuthStatus.signedIn;
      _userId = user?.uid ?? "";
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_authStatus) {
      AuthStatus.notSignedIn => LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        ),
      AuthStatus.signedIn => HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
          userId: _userId,
        ),
    };
  }
}
