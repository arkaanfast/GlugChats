import 'package:GlugChat/models/contact_model.dart';
import 'package:GlugChat/services/friends.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController _addFriendController = TextEditingController();
  List<ContactModel> _searchedFriend = [];
  bool loading = false;
  bool add = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add A Friend"),
        backgroundColor: Colors.pink[300],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Stack(
                children: [
                  TextField(
                      controller: _addFriendController,
                      onChanged: (val) {
                        if (val.isEmpty) {
                          if (_searchedFriend.length > 0) {
                            setState(() {
                              _searchedFriend.removeLast();
                              loading = false;
                              error = "";
                            });
                          } else {
                            setState(() {
                              error = "";
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter Username...",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                  color: Colors.pink[300], width: 2.0)))),
                  Positioned(
                    right: 10,
                    top: 5,
                    child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          FriendsService()
                              .searchFriend(
                                  _addFriendController.text.toLowerCase())
                              .then((result) {
                            if (result["message"] == "No user exists") {
                              setState(() {
                                loading = false;
                                error = "No user exists";
                              });
                            }
                            if (result["message"] == "Already added") {
                              setState(() {
                                _searchedFriend.add(ContactModel(
                                    name: result["friendName"],
                                    phrase: result["friendTitle"],
                                    alreadyAdded: true));
                              });
                            } else {
                              setState(() {
                                loading = false;
                                error = "";
                                _searchedFriend.add(ContactModel(
                                    name: result["friendName"],
                                    phrase: result["friendTitle"]));
                              });
                            }
                          });
                        }),
                  )
                ],
              ),
            ),
          ),
          error.isEmpty
              ? Container()
              : Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
          _searchedFriend.length == 0
              ? loading == true
                  ? Container(
                      margin: EdgeInsets.only(top: 50.0),
                      child: CircularProgressIndicator())
                  : Container()
              : Container(
                  width: 400.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(width: 1.0, color: Colors.grey)),
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 15,
                        left: 15,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage("assets/images/glug_logo.png"),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Positioned(
                        top: 15,
                        left: 90,
                        child: Text(
                          _searchedFriend[0].name ?? "",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black54),
                        ),
                      ),
                      Positioned(
                        top: 45,
                        left: 90,
                        child: Text(
                          _searchedFriend[0].phrase ?? "",
                          style: TextStyle(fontSize: 23.0, color: Colors.black),
                        ),
                      ),
                      _searchedFriend[0].alreadyAdded == true
                          ? Positioned(
                              top: 30, right: 20, child: Icon(Icons.done))
                          : Positioned(
                              top: 20,
                              right: 10,
                              child: IconButton(
                                  iconSize: 25.0,
                                  color: Colors.pink[400],
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      add = true;
                                    });
                                    FriendsService()
                                        .addFriend(_searchedFriend[0].name,
                                            _searchedFriend[0].phrase, context)
                                        .then((result) {
                                      setState(() {
                                        _searchedFriend[0].alreadyAdded = true;
                                        add = false;
                                      });
                                    });
                                  }))
                    ],
                  ),
                ),
          add == true ? CircularProgressIndicator() : Container()
        ],
      ),
    );
  }
}
