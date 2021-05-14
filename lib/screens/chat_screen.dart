import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
  static const String id = 'chat_screen';
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
   final _auth = FirebaseAuth.instance;
   final _firestore = FirebaseFirestore.instance;
   User loggedInUser;
   String messageText;

   void messageStream() async {
     await for(var snapshot in _firestore.collection('messages').snapshots()) {
       for (var message in snapshot.docs) {
         print(message.data());
       }
     }
   }

   void getCurrentUser()  {
     try {
     final user = _auth.currentUser;

     if(user != null) {
       loggedInUser = user;
     }}
     catch(e) {
       print(e);
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
                //_auth.signOut();
                //Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder <QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                // ignore: missing_return
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                  final messages = snapshot.data.docs;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages ) {
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final messageBubble = MessageBubble(message: messageText, sender: messageSender);
                    // ignore: missing_return, missing_return
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      children: messageBubbles,
                    ),
                  );

              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //messageText + loggedInUser.email
                      _firestore.collection('messages').add({'text': messageText, 'sender': loggedInUser.email });


                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({@required this.message, @required this.sender});
  final String message;
  final String sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Material(
        color: Colors.lightBlueAccent,
        child: Text(
            '$message from $message ',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white
            ),
        ),
      ),
    );
  }
}

