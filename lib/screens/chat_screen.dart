import 'package:chat_app_flutter/widgets/messages.dart';
import 'package:chat_app_flutter/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          Divider(
            thickness: 2,
            color: Theme.of(context).primaryColor,
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
// Firestore.instance
//     .collection('chats/fmiLDp2kp75n0mPi2WTU/messages')
// .add({'text': 'Hello there'});
