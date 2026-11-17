import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SnackbarScreen extends StatelessWidget {
  static const String name = 'snackbar_screen';

  const SnackbarScreen({super.key});

  void mostrarSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Este es un SnackBar de ejemplo'),
          action: SnackBarAction(
            label: 'Cerrar',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
  }

  void mostrarDialogo(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Confirmar acción?'),
        content: const Text(
          'Este diálogo es una demostración; no se ejecutará nada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar y diálogos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeIn(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () => mostrarSnackbar(context),
                child: const Text('Mostrar SnackBar'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => mostrarDialogo(context),
                child: const Text('Mostrar diálogo'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => showAboutDialog(
                  context: context,
                  applicationName: 'Caja de Widgets',
                  applicationVersion: '1.0.0',
                  children: [
                    const Text('Demostración de widgets de Material 3.'),
                  ],
                ),
                child: const Text('Acerca de / Licencias'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
