import 'dart:convert';
import 'package:GlugChat/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class ChatService {
  final databaseReference = Firestore.instance;

  Future pushChats(String message, String chatRoomId) async {
    String url = "http://10.0.2.2:3000/chat/";
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    String userName = pref.getString("userName");
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json =
        '{"chatRoomId": "$chatRoomId", "time": "${DateTime.now().microsecondsSinceEpoch}", "message": "$message", "sendBy": "$userName"}';
    Response response = await post(url, headers: headers, body: json);
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  Stream<List<ChatModel>> getAllChats(String chatRoomId) {
    return databaseReference
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("Messages")
        .orderBy("time", descending: false)
        .snapshots()
        .map(_convertToChatList);
  }

  List<ChatModel> _convertToChatList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ChatModel(
          message: doc.data["message"], sendBy: doc.data["sendBy"]);
    }).toList();
  }
}
