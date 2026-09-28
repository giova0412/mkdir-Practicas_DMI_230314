import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterFunctionsScreen extends StatefulWidget {
  const CounterFunctionsScreen({super.key});

  @override
  State<CounterFunctionsScreen> createState() => _CounterFunctionsScreenState();
}

class _CounterFunctionsScreenState extends State<CounterFunctionsScreen> {
  int clickCounter = 0;

  /// Devuelve el color según el valor del contador.
  Color _getCounterColor() {
    if (clickCounter > 0) return Colors.green;
    if (clickCounter < 0) return Colors.red;
    return Colors.blue;
  }

  void _increment() {
    setState(() {
      clickCounter++;
    });
  }

  void _decrement() {
    setState(() {
      clickCounter--;
    });
  }

  void _reset() {
    setState(() {
      clickCounter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final counterColor = _getCounterColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counter Functions Screen',
          style: GoogleFonts.dancingScript(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: counterColor.withOpacity(0.15),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Número del contador con color dinámico y tipografía Dancing Script
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: GoogleFonts.dancingScript(
                fontSize: 160,
                fontWeight: FontWeight.w700,
                color: counterColor,
              ),
              child: Text('$clickCounter'),
            ),
            Text(
              'Clicks',
              style: GoogleFonts.dancingScript(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: counterColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón de reiniciar
          FloatingActionButton(
            heroTag: 'resetBtn',
            backgroundColor: Colors.blue,
            onPressed: _reset,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(height: 12),
          // Botón de restar
          FloatingActionButton(
            heroTag: 'decrementBtn',
            backgroundColor: Colors.red,
            onPressed: _decrement,
            child: const Icon(Icons.remove, color: Colors.white),
          ),
          const SizedBox(height: 12),
          // Botón de sumar
          FloatingActionButton(
            heroTag: 'incrementBtn',
            backgroundColor: Colors.green,
            onPressed: _increment,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
