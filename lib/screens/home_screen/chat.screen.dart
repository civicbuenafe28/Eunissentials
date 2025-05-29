import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.username = 'User', required String recipientName});

  final String? username;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  ChatMessage? _replyToMessage;

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
          replyTo: _replyToMessage,
        ));
        _messageController.clear();
        _replyToMessage = null;
      });
      _scrollToBottom();
    }
  }

  Future<void> _attachPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add(ChatMessage(
          imagePath: image.path,
          isMe: true,
          timestamp: DateTime.now(),
          replyTo: _replyToMessage,
        ));
        _replyToMessage = null;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _showPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View Profile Pressed')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _unsentMessage(int index) {
    setState(() {
      if (_messages[index].isMe) {
        _messages.removeAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message unsent')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only unsent your own messages')),
        );
      }
    });
  }

  void _showMessageOptions(BuildContext context, int index) {
    final message = _messages[index];
    if (message.isMe) {
      showModalBottomSheet(
        context: context,
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _replyToMessage = message;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Unsent'),
              onTap: () {
                Navigator.pop(context);
                _unsentMessage(index);
              },
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Options not available for received messages')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF8B0000),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              widget.username ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showPopupMenu(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.isMe;
                final color = isMe ? Colors.blue[200] : Colors.grey[300];
                final textColor = isMe ? Colors.white : Colors.black87;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe) const SizedBox(width: 24),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          color: color,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (message.replyTo != null)
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${message.replyTo!.isMe ? 'You' : widget.username ?? 'User'}: ${message.replyTo!.text ?? '[Photo]'}',
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                if (message.text != null)
                                  Text(message.text!, style: TextStyle(color: textColor)),
                                if (message.imagePath != null)
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Image.file(File(message.imagePath!), fit: BoxFit.cover),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM d, h:mm a').format(message.timestamp),
                                  style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (isMe)
                        InkWell(
                          onTap: () => _showMessageOptions(context, index),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.more_vert, size: 20),
                          ),
                        ),
                      if (!isMe) const SizedBox(width: 24),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF8B0000),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 2,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_outlined, color: Colors.white),
                  onPressed: _attachPhoto,
                  tooltip: 'Attach Photo',
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_replyToMessage != null)
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Replying to: ${_replyToMessage!.isMe ? 'You' : widget.username ?? 'User'}: ${_replyToMessage!.text ?? '[Photo]'}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _replyToMessage = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                  tooltip: 'Send Message',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String? text;
  final String? imagePath;
  final bool isMe;
  final DateTime timestamp;
  final ChatMessage? replyTo;

  ChatMessage({
    this.text,
    this.imagePath,
    required this.isMe,
    required this.timestamp,
    this.replyTo,
  });
}
