import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/domain/entities/message.dart';
import 'package:flutter_application_2/presentation/providers/chat_provider.dart';
import 'package:flutter_application_2/presentation/widgets/chat/her_message_bubble.dart';
import 'package:flutter_application_2/presentation/widgets/chat/my_message_buble.dart';
import 'package:flutter_application_2/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'),
          ),
        ),
        title: const Text('Mi amor ♥'),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: chatProvider.chatScrollController,
                itemCount: chatProvider.messageList.length,
                itemBuilder: (context, index) {
                  final message = chatProvider.messageList[index];
                  return (message.fromWho == FromWho.hers)
                      ? HerMessageBubble(message: message)
                      : MyMessageBubble(message: message);
                },
              ),
            ),
            MessageFieldBox(
              onValue: (value) {
                chatProvider.sendMessage(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
