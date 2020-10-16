import 'package:GlugChat/screens/authentication/launch_screen.dart';
import 'package:GlugChat/screens/home/chat_contacts.dart';
import 'package:GlugChat/screens/wrapper.dart';
import 'package:GlugChat/services/auth_service.dart';
import 'package:GlugChat/shared/input_decoration.dart';
import 'package:GlugChat/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String userName = "";
  String password = "";
  String error = "";
  bool loading = false;
  final _signInFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double blockWidth = width / 100;
    double blockHeight = height / 100;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Sign In",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Colors.pink[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LaunchScreen()));
          },
        ),
      ),
      body: loading
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _signInFormKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Username'),
                      validator: (username) =>
                          username.isEmpty ? "Enter a User Name" : null,
                      onChanged: (val) {
                        userName = val;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (password) => password.length < 6
                          ? "Enter a password 6 chars long "
                          : null,
                      onChanged: (val) {
                        password = val;
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                        color: Colors.pink,
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white, fontSize: 23.0),
                        ),
                        onPressed: () {
                          if (_signInFormKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            AuthService()
                                .userSignIn(userName.toLowerCase(), password)
                                .then((result) {
                              if (result == "Auth Failed incorrect password") {
                                setState(() {
                                  error = "Incorrect Password";
                                  loading = false;
                                });
                              }
                              if (result == "Auth Failed") {
                                setState(() {
                                  error = "Auth Failed ( Did you Sign In ? )";
                                  loading = false;
                                });
                              }
                              if (result["message"] == "Done") {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()));
                              } else {
                                setState(() {
                                  loading = false;
                                  error = "Try again later";
                                });
                              }
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              )),
    );
  }
}
