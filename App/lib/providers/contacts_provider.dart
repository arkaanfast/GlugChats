import 'package:GlugChat/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contacts = [];

  addContacts(jsonResponse) {
    for (int i = 0; i < jsonResponse.length; ++i) {
      contacts.add(ContactModel(
          name: jsonResponse[i]["friendName"],
          phrase: jsonResponse[i]["friendTitle"],
          chatRoomId: jsonResponse[i]["chatRoomID"]));
    }
  }

  void addSingleContact(jsonResponse) {
    contacts.add(ContactModel(
        name: jsonResponse["friendName"],
        phrase: jsonResponse["friendTitle"],
        chatRoomId: jsonResponse["chatRoomID"]));
    notifyListeners();
  }
  
   void clearAll() {
    contacts.clear();
  }
  
}
