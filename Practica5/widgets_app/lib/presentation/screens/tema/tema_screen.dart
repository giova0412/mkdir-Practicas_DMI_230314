import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets_app/presentation/providers/tema_provider.dart';

class TemaScreen extends ConsumerWidget {
  static const String name = 'tema_screen';

  const TemaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(temaNotifierProvider);
    final List<Color> paleta = ref.watch(paletaProvider);
    final notifier = ref.read(temaNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar tema'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: Icon(
              appTheme.modoOscuro
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            title: const Text('Modo oscuro'),
            subtitle: Text(appTheme.modoOscuro ? 'Activado' : 'Desactivado'),
            value: appTheme.modoOscuro,
            onChanged: (_) => notifier.alternarModoOscuro(),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Color de acento',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (int i = 0; i < paleta.length; i++)
                  _ColorOpcion(
                    color: paleta[i],
                    seleccionado: appTheme.indiceColor == i,
                    onTap: () => notifier.cambiarIndiceColor(i),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorOpcion extends StatelessWidget {
  final Color color;
  final bool seleccionado;
  final VoidCallback onTap;

  const _ColorOpcion({
    required this.color,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: seleccionado ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
        ),
        child: seleccionado
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}
