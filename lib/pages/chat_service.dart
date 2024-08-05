import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createChatRoom(String chatroomId, List<String> participants) {
    _firestore.collection('chatrooms').doc(chatroomId).set({
      'participants': participants,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> sendMessage(
      String chatroomId, String senderId, String text) async {
    if (text.trim().isEmpty) return;
    await _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .add({
      'text': text.trim(),
      'senderId': senderId,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMessages(String chatroomId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
