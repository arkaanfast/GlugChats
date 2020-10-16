import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String url = "http://10.0.2.2:3000/auth/";

  Future userSignUp(
      String email, String userName, String password, String title) async {
    String signUpUrl = url + "signup";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"email": "$email", "userName": "$userName", "password": "$password", "title": "$title"}';
    Response response = await post(signUpUrl, headers: headers, body: json);
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
    if (response.statusCode == 409) {
      return jsonResponse["message"];
    }
    if (response.statusCode == 400) {
      return "Retry";
    }
  }

  Future userSignIn(String userName, String password) async {
    final pref = await SharedPreferences.getInstance();
    String signInUrl = url + "signin";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"userName": "$userName", "password": "$password"}';
    Response response = await post(signInUrl, headers: headers, body: json);
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      pref.setString("userEmail", jsonResponse["userEmail"]);
      pref.setString("userName", jsonResponse["userName"]);
      pref.setString("userTitle", jsonResponse["userTitle"]);
      pref.setString("token", jsonResponse["token"]);
      pref.setBool("isSignedIn", true);
      return jsonResponse;
    }

    if (response.statusCode == 401) {
      return jsonResponse["message"];
    }

    if (response.statusCode == 404) {
      return jsonResponse["message"];
    }
  }
}
