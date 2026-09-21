import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  // Intercala burbujas: par = yo, impar = ella
                  return index.isEven
                      ? const MyMessageBubble()
                      : const HerMessageBubble();
                },
              ),
            ),

            // Caja de texto para escribir mensajes
            MessageFieldBox(
              onValue: (value) {
                // Aquí recibes el texto que el usuario envió
                print('Mensaje enviado: $value');
              },
            ),
          ],
        ),
      ),
    );
  }
}
