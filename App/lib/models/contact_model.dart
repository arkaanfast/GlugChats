import 'package:flutter/material.dart';

class ContactModel {
  String name;
  String phrase;
  // String imageUrl;
  bool alreadyAdded = false;
  String chatRoomId;
  ContactModel(
      {@required this.name,
      @required this.phrase,
      this.alreadyAdded,
      this.chatRoomId});
}
