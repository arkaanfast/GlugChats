import 'package:GlugChat/providers/contacts_provider.dart';
import 'package:GlugChat/screens/home/add_friend.dart';
import 'package:GlugChat/screens/home/chat_area.dart';
import 'package:GlugChat/screens/wrapper.dart';
import 'package:GlugChat/services/friends.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ChatContacts extends StatefulWidget {
  final String userName;
  final String title;

  ChatContacts({this.userName, this.title});

  @override
  _ChatContactsState createState() => _ChatContactsState();
}

class _ChatContactsState extends State<ChatContacts> {
  @override
  Widget build(BuildContext context) {
    ContactProvider _contactProvider = Provider.of<ContactProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.pink[300],
          title: Text(
            "GlugChats",
            style: TextStyle(fontSize: 25.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFriend()));
              },
            )
          ],
        ),
        drawer: _drawer(context, _contactProvider),
        body: FutureBuilder(
          future: FriendsService().getAllFriends(widget.userName, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == "No friends macha") {
                return Center(child: Text("Add Friends"));
              }
              return ListView.builder(
                itemCount: _contactProvider.contacts.length,
                itemBuilder: (context, index) {
                  return _contactTile(context, index, _contactProvider);
                },
              );
            }
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.pink,
            ));
          },
        ),
      ),
    );
  }

  Widget _drawer(context, _contactProvider) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.pink[100]),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, border: Border.all(width: 1.0)),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/images/glug_logo.png"),
                  ),
                ),
              ),
              Positioned(
                top: 25,
                left: 118,
                child: Text(
                  widget.userName.toUpperCase(),
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
              ),
              Positioned(
                top: 55,
                left: 118,
                child: Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        // ListTile(
        //   leading: Icon(
        //     Icons.account_circle,
        //     size: 50.0,
        //     color: Colors.pink[300],
        //   ),
        //   title: Text(
        //     "Account",
        //     style: TextStyle(fontSize: 20.0, color: Colors.grey),
        //   ),
        // ),

        ListTile(
          leading: Icon(
            Icons.info,
            size: 50.0,
            color: Colors.pink[300],
          ),
          title: Text(
            "About GLUG",
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
          onTap: () async {
            final pref = await SharedPreferences.getInstance();
            pref.setBool("isSignedIn", false);
            _contactProvider.contacts = [];
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Wrapper()));
          },
          child: ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 50.0,
              color: Colors.pink[300],
            ),
            title: Text(
              "Log Out",
              style: TextStyle(fontSize: 20.0, color: Colors.grey),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _contactTile(context, int index, _contactProvider) {
    return Container(
      width: 200.0,
      height: 90.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(width: 1.0, color: Colors.grey)),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/glug_logo.png"),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Positioned(
            top: 15,
            left: 90,
            child: Text(
              _contactProvider.contacts[index].name,
              style: TextStyle(fontSize: 20.0, color: Colors.black54),
            ),
          ),
          Positioned(
            top: 45,
            left: 90,
            child: Text(
              _contactProvider.contacts[index].phrase,
              style: TextStyle(fontSize: 23.0, color: Colors.black),
            ),
          ),
          Positioned(
              top: 20,
              right: 10,
              child: IconButton(
                iconSize: 25.0,
                color: Colors.pink[400],
                icon: Icon(Icons.send),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatArea(
                              name: _contactProvider.contacts[index].name,
                              chatRoomId: _contactProvider
                                  .contacts[index].chatRoomId)));
                },
              ))
        ],
      ),
    );
  }
}
