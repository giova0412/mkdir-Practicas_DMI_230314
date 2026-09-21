import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HerMessageBubble extends StatelessWidget {
  const HerMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: colors.secondary, borderRadius: BorderRadius.circular(20)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Hola Mundo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 5),

        const _ImageBubble(),

        const SizedBox(height: 10),
      ],
    );
  }
}

class _ImageBubble extends StatefulWidget {
  const _ImageBubble();

  @override
  State<_ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<_ImageBubble> {
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  Future<void> _getImage() async {
    final response = await http.get(Uri.parse('https://yesno.wtf/api'));
    final json = jsonDecode(response.body);
    setState(() => imageUrl = json['image']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (imageUrl.isEmpty) {
      return Container(
        width: size.width * 0.7,
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: const Text('Mi amor está enviando una imagen...'),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        imageUrl,
        width: size.width * 0.7,
        height: 150,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            width: size.width * 0.7,
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const Text('Mi amor está enviando una imagen...'),
          );
        },
      ),
    );
  }
}