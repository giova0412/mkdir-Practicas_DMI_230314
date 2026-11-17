import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AppTutorialScreen extends StatefulWidget {
  static const String name = 'tutorial_screen';

  const AppTutorialScreen({super.key});

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {
  final PageController controller = PageController();
  int pagina = 0;

  static const paginas = <_TutorialPage>[
    _TutorialPage(
      titulo: 'Bienvenido a Caja de Widgets',
      descripcion: 'Explora demostraciones de los componentes de Material 3.',
      icono: Icons.widgets_outlined,
      color: Color(0xFF00695C),
    ),
    _TutorialPage(
      titulo: 'Navega entre secciones',
      descripcion: 'Usa el menú lateral o la lista para abrir cada demo.',
      icono: Icons.menu_open_rounded,
      color: Color(0xFF283593),
    ),
    _TutorialPage(
      titulo: 'Personaliza el tema',
      descripcion: 'Cambia entre modo claro y oscuro y elige tu color.',
      icono: Icons.palette_outlined,
      color: Color(0xFF6A1B9A),
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esUltima = pagina == paginas.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (valor) => setState(() => pagina = valor),
            children: [
              for (final p in paginas) _TutorialPagina(page: p),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Saltar'),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FilledButton.icon(
                onPressed: () {
                  if (esUltima) {
                    Navigator.pop(context);
                  } else {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
                icon: Icon(esUltima ? Icons.check : Icons.arrow_forward_rounded),
                label: Text(esUltima ? 'Comenzar' : 'Siguiente'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialPagina extends StatelessWidget {
  final _TutorialPage page;

  const _TutorialPagina({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [page.color, page.color.withValues(alpha: 0.6)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZoomIn(
                child: Icon(page.icono, size: 140, color: Colors.white),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                child: Text(
                  page.titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                child: Text(
                  page.descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialPage {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;

  const _TutorialPage({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
  });
}
