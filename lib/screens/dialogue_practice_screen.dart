import 'package:flutter/material.dart';

class DialoguePracticeScreen extends StatefulWidget {
  const DialoguePracticeScreen({super.key});

  @override
  State<DialoguePracticeScreen> createState() => _DialoguePracticeScreenState();
}

class _DialoguePracticeScreenState extends State<DialoguePracticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('对话练习'),
      ),
      body: const Center(
        child: Text('对话练习页面 - 开发中'),
      ),
    );
  }
}
