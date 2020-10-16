import 'package:GlugChat/screens/authentication/sign_in.dart';
import 'package:GlugChat/services/auth_service.dart';
import 'package:GlugChat/shared/input_decoration.dart';
import 'package:GlugChat/shared/loading.dart';
import 'package:flutter/material.dart';

import 'launch_screen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userName = "";
  String email = "";
  String password = "";
  String title = "";
  String error = "";
  bool loading = false;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
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
            "Register",
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
        body: loading ? Loading() : registerForm(context));
  }

  Widget registerForm(context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (email) => email.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    email = val;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _userNameController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Username'),
                  validator: (username) =>
                      username.isEmpty ? "Enter Username" : null,
                  onChanged: (val) {
                    userName = val;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _titleController,
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  validator: (title) => title.isEmpty ? "Enter Title" : null,
                  onChanged: (val) {
                    title = val;
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
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Confirm Password'),
                  validator: (confirmpassword) => confirmpassword != password
                      ? "Passwords dont match"
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
                    child: Text(
                  error,
                  style: TextStyle(color: Colors.red),
                )),
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
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 23.0),
                    ),
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        _authService
                            .userSignUp(
                                email, userName.toLowerCase(), password, title)
                            .then((result) => {
                                  if (result == "Email already exists")
                                    {
                                      setState(() {
                                        error = "Email already exists";
                                        loading = false;
                                      })
                                    }
                                  else if (result == "User Name already exists")
                                    {
                                      setState(() {
                                        error = "User name already exists";
                                        loading = false;
                                      })
                                    }
                                  else if (result == "Error")
                                    {
                                      setState(() {
                                        error = "Try again";
                                        loading = false;
                                      })
                                    }
                                  else
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignIn()))
                                    }
                                });
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
