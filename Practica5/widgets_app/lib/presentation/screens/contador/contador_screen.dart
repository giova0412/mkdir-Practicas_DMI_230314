import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets_app/presentation/providers/contador_provider.dart';
import 'package:widgets_app/presentation/providers/tema_provider.dart';

class ContadorScreen extends ConsumerWidget {
  static const String name = 'contador_screen';

  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int valor = ref.watch(contadorProvider);
    final bool modoOscuro = ref.watch(temaNotifierProvider).modoOscuro;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador con Riverpod'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: modoOscuro ? 'Modo claro' : 'Modo oscuro',
            icon: Icon(
              modoOscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () =>
                ref.read(temaNotifierProvider.notifier).alternarModoOscuro(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Valor actual', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            FadeIn(
              key: ValueKey(valor),
              child: Text(
                '$valor',
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: () => ref.read(contadorProvider.notifier).state--,
                  icon: const Icon(Icons.remove),
                  label: const Text('Restar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => ref.read(contadorProvider.notifier).state = 0,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reiniciar'),
                ),
                FilledButton.icon(
                  onPressed: () => ref.read(contadorProvider.notifier).state++,
                  icon: const Icon(Icons.add),
                  label: const Text('Sumar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
