import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'chat_service.dart';

class ChatroomListPage extends StatelessWidget {
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatrooms'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var chatrooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatrooms.length,
            itemBuilder: (context, index) {
              var chatroom = chatrooms[index];
              var participants = chatroom['participants'];
              return ListTile(
                title: Text('Chatroom ${chatroom.id}'),
                subtitle: Text(participants.join(', ')),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    chatroom.id.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(chatroomId: chatroom.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
