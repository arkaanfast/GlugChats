import 'dart:convert';
import 'package:GlugChat/providers/contacts_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class FriendsService {
  String url = "http://10.0.2.2:3000/user/";

  Future searchFriend(String friendName) async {
    final pref = await SharedPreferences.getInstance();
    String userName = pref.getString("userName");
    String token = pref.getString("token");
    String searchFriendUrl = url + "$userName/" + "$friendName";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    Response response = await get(searchFriendUrl, headers: headers);
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    } else {
      return jsonResponse;
    }
  }

  Future addFriend(String friendName, String friendTitle, context) async {
    ContactProvider _contactProvider =
        Provider.of<ContactProvider>(context, listen: false);

    final pref = await SharedPreferences.getInstance();
    String userName = pref.getString("userName");
    String userTitle = pref.getString("userTitle");
    String token = pref.getString("token");
    String addFriendUrl = url + "addfriend";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json =
        '{"userName": "$userName", "title": "$userTitle", "friendName": "$friendName", "friendTitle": "$friendTitle"}';
    Response response = await post(addFriendUrl, body: json, headers: headers);
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _contactProvider.addSingleContact(jsonResponse);
      return jsonResponse;
    } else {
      return jsonResponse["message"];
    }
  }

  Future getAllFriends(String userName, context) async {
    ContactProvider _contactProvider = Provider.of<ContactProvider>(context);
    String getAllFriendsUrl = url + "allfriends/" + userName;
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    Response response = await get(getAllFriendsUrl, headers: headers);
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse["message"] == "No friends macha") {
        return jsonResponse["message"];
      } else {
        if (jsonResponse["friendsData"].length ==
            _contactProvider.contacts.length) {
          return null;
        } else {
          return _contactProvider.addContacts(jsonResponse["friendsData"]);
        }
      }
    } else {
      return response.statusCode;
    }
  }
}
