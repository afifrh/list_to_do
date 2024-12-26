import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.auth,
    required this.onSignedIn,
  });

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _logoAnimation;
  String? _email;
  String? _password;
  String? _emailPassword;
  final FocusNode _passwordFocusNode = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _logoAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _logoAnimation.addListener(() => setState(() {}));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      await _login();
    }
  }

  Future<void> _login() async {
    try {
      final uid = await widget.auth.signIn(_email!, _password!);
      print("Signed in : $uid");

      final isVerified = await widget.auth.isEmailVerified();
      if (isVerified) {
        print("Verified");
        widget.onSignedIn();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Email Not Verified!"),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: "Send Again",
              onPressed: () async {
                await widget.auth.sendEmailVerification();
              },
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1001));
        await widget.auth.signOut();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error in Signing in!")),
      );
      print("Error: $e");
    }
  }

  Future<void> _passwordReset() async {
    final form = _resetFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      try {
        await widget.auth.resetPassword(_emailPassword!);
        if (!mounted) return;

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password Reset Email Sent")),
        );
      } catch (e) {
        await Fluttertoast.showToast(
          msg: "Invalid Input!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "assets/images/login.jpg",
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 25.0),
                Image.asset(
                  "assets/images/loginlogo.png",
                  height: _logoAnimation.value * 150,
                  width: _logoAnimation.value * 150,
                ),
                const SizedBox(height: 60.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          labelText: "Email",
                          labelStyle:
                              const TextStyle(color: Colors.yellowAccent),
                          hintStyle: TextStyle(
                            color: Colors.blueAccent.withOpacity(.45),
                          ),
                          prefixIcon: const Icon(
                            Icons.mail,
                            color: Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.blue),
                        validator: (val) =>
                            val?.contains('@') != true ? "Invalid Email" : null,
                        onSaved: (val) => _email = val,
                        onFieldSubmitted: (_) =>
                            _passwordFocusNode.requestFocus(),
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          labelText: "Password",
                          labelStyle:
                              const TextStyle(color: Colors.yellowAccent),
                          hintStyle: TextStyle(
                            color: Colors.blueAccent.withOpacity(.45),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: Colors.blue),
                        validator: (val) => (val?.length ?? 0) < 6
                            ? "Password too short"
                            : null,
                        onSaved: (val) => _password = val,
                        focusNode: _passwordFocusNode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60.0),
                SizedBox(
                  height: 45.0,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[400]?.withOpacity(.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Karla",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(PageNavigate(auth: widget.auth));
                  },
                  child: const Text(
                    "New User? Sign Up!",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Karla",
                      fontSize: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () => _showResetPasswordDialog(),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Karla",
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showResetPasswordDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text("Reset Password"),
          content: Form(
            key: _resetFormKey,
            child: TextFormField(
              onSaved: (val) => _emailPassword = val,
              validator: (val) =>
                  val?.contains('@') != true ? "Invalid Email" : null,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.blue),
              decoration: InputDecoration(
                hintText: "Enter Email",
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: _passwordReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PageNavigate extends CupertinoPageRoute<void> {
  PageNavigate({required BaseAuth auth})
      : super(
          builder: (BuildContext context) => RegistrationPage(
            auth: auth,
          ),
        );
}
