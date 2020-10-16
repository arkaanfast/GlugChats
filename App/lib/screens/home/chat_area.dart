import 'package:GlugChat/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatArea extends StatefulWidget {
  final String name;
  final String chatRoomId;

  ChatArea({this.name, this.chatRoomId});
  @override
  _ChatAreaState createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.pink[300],
        title: Text(
          widget.name,
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: ChatService().getAllChats(widget.chatRoomId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            alignment:
                                snapshot.data[index].sendBy == widget.name
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 0.0,
                                    top: 8.0,
                                    right: 8.0,
                                    left: 8.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0)),
                                    border: Border.all(width: 0.8)),
                                child: Text(
                                  snapshot.data[index].message,
                                  style: TextStyle(fontSize: 18.0),
                                )),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: "Type here...",
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
                ),
                IconButton(
                  onPressed: () {
                    ChatService()
                        .pushChats(
                      _messageController.text.toLowerCase(),
                      widget.chatRoomId,
                    )
                        .then((result) {
                      if (result["message"] == "Sent") {
                        _messageController.text = "";
                      }
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
