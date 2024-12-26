import 'package:flutter/material.dart';
import 'package:todo/services/auth.dart';
import 'root_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    required this.auth,
  });

  final BaseAuth auth;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _name;
  String? _email;
  String? _password;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      print("Name: $_name Email: $_email Password: $_password");
      await _register();
    }
  }

  Future<void> _register() async {
    try {
      final uid = await widget.auth.createUser(_email!, _password!);
      print("uid: $uid");

      await widget.auth.sendEmailVerification();
      await widget.auth.signOut();

      if (!mounted) return;

      await Fluttertoast.showToast(
        msg: "Verification Email Sent! Verify to Login",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );

      if (!mounted) return;

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => RootPage(auth: widget.auth),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error: $e");
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
            "assets/images/registration.jpg",
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: <Widget>[
                const Center(
                  child: Text(
                    "User Registration",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: "Pacifico",
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 90.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Your Name",
                          labelText: "Name",
                          labelStyle:
                              const TextStyle(color: Colors.yellowAccent),
                          hintStyle: TextStyle(
                            color: Colors.blueAccent.withOpacity(.45),
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.blue),
                        validator: (val) =>
                            (val?.length ?? 0) < 1 ? "Invalid Name" : null,
                        onSaved: (val) => _name = val,
                        onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocusNode,
                        decoration: InputDecoration(
                          hintText: "Enter Your Email",
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
                        focusNode: _passwordFocusNode,
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
                        style: const TextStyle(color: Colors.blue),
                        validator: (val) => (val?.length ?? 0) < 6
                            ? "Password too short"
                            : null,
                        onSaved: (val) => _password = val,
                        obscureText: true,
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
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Karla",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RootPage(auth: widget.auth),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "Already Registered? Log In",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Karla",
                      fontSize: 24.0,
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
}
