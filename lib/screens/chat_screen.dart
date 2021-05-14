import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;


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
   final  messageTextController = TextEditingController();
   final _auth = FirebaseAuth.instance;
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
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
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
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)
            ),
            elevation: 5.0,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                  '$message',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

