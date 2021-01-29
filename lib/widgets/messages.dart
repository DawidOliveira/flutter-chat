import 'package:chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final chatDocs = snapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, i) {
            return MessageBubble(
              message: chatDocs[i].get('text'),
              username: chatDocs[i].get('username'),
              imageUrl: chatDocs[i].get('user_image'),
              belongsToMe: FirebaseAuth.instance.currentUser.uid ==
                  chatDocs[i].get('user_id'),
              key: ValueKey(chatDocs[i].id),
            );
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
