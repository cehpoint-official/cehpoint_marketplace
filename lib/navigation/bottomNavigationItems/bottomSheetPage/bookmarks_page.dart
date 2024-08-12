// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi',
    'hi3',
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/chat_bg.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
            _buildInputBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBox() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add(_textController.text);
        _textController.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
