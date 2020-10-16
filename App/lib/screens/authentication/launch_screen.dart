import 'package:GlugChat/screens/authentication/register.dart';
import 'package:GlugChat/screens/authentication/sign_in.dart';
import 'package:GlugChat/widgets/auth_screen_button.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double blockWidth = width / 100;
    double blockHeight = height / 100;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/glug_chat_bg.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 105,
              right: 90,
              child: Transform.scale(
                  scale: 2.5,
                  child: Image.asset("assets/images/glug_logo.png")),
            ),
            Positioned(
              top: 310,
              left: 105,
              child: Text(
                "GlugChats",
                style: TextStyle(fontSize: 45.0, color: Colors.white),
              ),
            ),
            Positioned(
              top: 250,
              left: 60,
              child: Text(
                "GNU/LINUX USERS GROUP PACE",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            Positioned(
                top: 410,
                left: 80,
                child: AuthScreenButton(
                  buttonContent: "Sign In",
                  blockHeight: blockHeight,
                  blockWidth: blockWidth,
                  nextScreen: SignIn(),
                )),
            Positioned(
                top: 490,
                left: 80,
                child: AuthScreenButton(
                  buttonContent: "Register",
                  blockHeight: blockHeight,
                  blockWidth: blockWidth,
                  nextScreen: Register(),
                )),
          ],
        ),
      ),
    );
  }
}
