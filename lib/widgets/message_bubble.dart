import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String userName;
  final String message;
  final bool isOwnText;
  final String imageUrl;

  const MessageBubble({Key key, this.message, this.isOwnText, this.userName, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isOwnText ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isOwnText ? Colors.grey : Colors.purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(imageUrl),
              ),
              Column(
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade200),
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
