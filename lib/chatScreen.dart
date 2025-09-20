import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Sends a message to Firestore.
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentUser == null) {
      return;
    }

    _messageController.clear();
    // Lose focus from the text field to hide the keyboard.
    FocusScope.of(context).unfocus();

    // Add the new message to the 'messages' collection.
    await FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'timestamp': Timestamp.now(),
      'senderId': _currentUser!.uid,
      'senderEmail': _currentUser!.email,
    });
  }

  // Scrolls to the bottom of the message list.
  void _scrollToBottom(int itemCount) {
    // A small delay ensures the list has built before we try to scroll.
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Be the first to send a message!'));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong...'));
                }

                final messages = snapshot.data!.docs;
                // Schedule the auto-scroll after the list has been built.
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom(messages.length));

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final data = message.data() as Map<String, dynamic>;
                    final bool isMe = data['senderId'] == _currentUser!.uid;

                    return _ChatBubble(
                      message: data['text'],
                      senderEmail: data['senderEmail'],
                      timestamp: data['timestamp'],
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          _MessageInputField(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// A styled chat bubble widget.
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.senderEmail,
    required this.timestamp,
    required this.isMe,
  });

  final String message;
  final String senderEmail;
  final Timestamp? timestamp;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe ? Colors.blueAccent : Colors.grey[600];
    final formattedTime = timestamp != null
        ? DateFormat('h:mm a').format(timestamp!.toDate())
        : '';

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
              isMe ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(16),
            ),
          ),
          child:
          Text(message, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "${isMe ? "You" : senderEmail.split('@')[0]} · $formattedTime",
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

// The text input field at the bottom of the chat screen.
class _MessageInputField extends StatelessWidget {
  const _MessageInputField({
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
