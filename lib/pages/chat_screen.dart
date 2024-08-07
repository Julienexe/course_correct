import 'package:course_correct/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatroomId;

  const ChatScreen({super.key, required this.chatroomId});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getMessages(widget.chatroomId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: message['senderId'] == appState.user!.uid
                            ? Colors.blue[100]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(message['text']),
                        subtitle: (message['senderId']== appState.user!.uid? const Text("You", style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10
                        ),): const Text("Tutor",style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10
                        ),)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    var user = _auth.currentUser;
    if (user == null) return;

    await _chatService.sendMessage(
        widget.chatroomId, user.uid, _controller.text);
    _controller.clear();
  }
}
