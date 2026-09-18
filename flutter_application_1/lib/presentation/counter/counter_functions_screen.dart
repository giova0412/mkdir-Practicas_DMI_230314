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
        backgroundColor: counterColor.withValues(alpha: 0.15),
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
          CustomButton(
            icon: Icons.refresh,
            backgroundColor: Colors.blue,
            onPressed: _reset,
          ),
          const SizedBox(height: 12),
          // Botón de restar
          CustomButton(
            icon: Icons.remove,
            backgroundColor: Colors.red,
            onPressed: _decrement,
          ),
          const SizedBox(height: 12),
          // Botón de sumar
          CustomButton(
            icon: Icons.add,
            backgroundColor: const Color.fromARGB(255, 57, 124, 59),
            onPressed: _increment,
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
