import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eunissentials/utils/global.colors.dart';
import 'package:eunissentials/screens/home_screen/chat.screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a sample list of usernames and messages for demonstration
    final List<Map<String, String>> messages = [
      {'username': 'John Doe', 'message': 'Hey, how are you?'},
      {'username': 'Jane Smith', 'message': 'When will the item be available?'},
      {'username': 'Alex Johnson', 'message': 'Is this still for sale?'},
      {'username': 'Maria Garcia', 'message': 'Thanks for the quick response!'},
      {'username': 'Robert Brown', 'message': 'Can you ship to this address?'},
      {'username': 'Sarah Wilson', 'message': 'I\'m interested in your product'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.textColor,
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageItem(
            username: messages[index]['username']!,
            message: messages[index]['message']!,
            onTap: () {
              // Navigate to chat screen with the username
              Get.to(() => ChatScreen(
                recipientName: messages[index]['username']!,
              ));
            },
          );
        },
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final String username;
  final String message;
  final VoidCallback onTap;

  const MessageItem({
    super.key,
    required this.username,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // User Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            // Username and Message Preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}