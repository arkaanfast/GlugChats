import 'package:flutter/material.dart';

class AuthScreenButton extends StatelessWidget {
  final String buttonContent;
  final double blockWidth;
  final double blockHeight;
  final Widget nextScreen;
  AuthScreenButton(
      {this.buttonContent, this.blockWidth, this.blockHeight, this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      width: this.blockWidth * 60.0,
      height: this.blockHeight * 8.0,
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.pink[400],
        child: Text(
          this.buttonContent,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => this.nextScreen)),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
