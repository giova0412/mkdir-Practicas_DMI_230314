import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AnimatedScreen extends StatefulWidget {
  static const String name = 'animated_screen';

  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  final Random random = Random();

  double ancho = 120;
  double alto = 120;
  Color color = Colors.indigo;
  double radio = 12;

  void cambiarForma() {
    setState(() {
      ancho = 70 + random.nextInt(180).toDouble();
      alto = 70 + random.nextInt(180).toDouble();
      radio = random.nextInt(80).toDouble();
      color = Color.fromRGBO(
        random.nextInt(200),
        random.nextInt(200),
        random.nextInt(200),
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenedor animado'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: const Text('AnimatedContainer en acción'),
            ),
            const SizedBox(height: 30),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              width: ancho,
              height: alto,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radio),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cambiarForma,
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
