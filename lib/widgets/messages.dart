import 'package:chat_app_flutter/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final chatDocs = snapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(10),
                  child: MessageBubble(
                      key: ValueKey(chatDocs[index].documentID),
                      // imageUrl: chatDocs[index]['user_image_url'],
                      userName: chatDocs[index]['username'],
                      imageUrl: chatDocs[index]['imageUrl'],
                      message: chatDocs[index]['text'].toString(),
                      isOwnText: chatDocs[index]['userId'] ==
                          futureSnapshot.data.uid)),
              itemCount: chatDocs.length,
            );
          },
        );
      },
    );
  }
}
