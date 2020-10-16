import 'package:GlugChat/screens/authentication/launch_screen.dart';
import 'package:GlugChat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/chat_contacts.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: next(),
      builder: (context, snapshot) {
        String userName;
        String userTitle;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data["isSignedIn"] == true) {
            userName = snapshot.data["userName"];
            userTitle = snapshot.data["userTitle"];

            return ChatContacts(
              userName: userName,
              title: userTitle,
            );
          }
          return LaunchScreen();
        }
        return Loading();
      },
    );
  }

  Future next() async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> check = {};
    if (pref.getBool("isSignedIn") == true) {
      check["isSignedIn"] = true;
      check["userName"] = pref.getString("userName");
      check["userTitle"] = pref.getString("userTitle");
      return check;
    } else {
      check["isSIgnedIn"] = false;
      return check;
    }
  }
}
