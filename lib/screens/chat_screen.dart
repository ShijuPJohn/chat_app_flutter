import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/fmiLDp2kp75n0mPi2WTU/messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final documents = snapshot.data.documents;
          return ListView.builder(
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(10),
              child: Text(documents[index]['text'].toString()),
            ),
            itemCount: documents.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance
              .collection('chats/fmiLDp2kp75n0mPi2WTU/messages').add({'text':'Hello there'});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
