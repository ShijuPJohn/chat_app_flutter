import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _textFieldController = TextEditingController();
  var _enteredMessage = '';

  Future<void> _sendMessage() async {
    _textFieldController.clear();
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userName = await Firestore.instance.collection('users').document(currentUser.uid).get();
    FocusScope.of(context).unfocus();
    await Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'timeStamp': Timestamp.now(),
      'userId': currentUser.uid,
      'username': userName.data['username'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _textFieldController,
          onChanged: (value) {
            setState(() {
              _enteredMessage = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Message',
          ),
        )),
        IconButton(
          onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          // Firestore.instance
          //     .collection('chats/fmiLDp2kp75n0mPi2WTU/messages')
          //     .add({'text': 'Hello there'});

          icon: Icon(Icons.send),
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
