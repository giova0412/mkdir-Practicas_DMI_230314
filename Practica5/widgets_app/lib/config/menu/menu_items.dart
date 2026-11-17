import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Contador',
    subTitle: 'Estado reactivo con Riverpod',
    link: '/contador',
    icon: Icons.exposure_plus_1_rounded,
  ),
  MenuItem(
    title: 'Botones',
    subTitle: 'Variantes de botones Material 3',
    link: '/buttons',
    icon: Icons.smart_button_outlined,
  ),
  MenuItem(
    title: 'Tarjetas',
    subTitle: 'Elevaciones, bordes y contenido',
    link: '/cards',
    icon: Icons.credit_card,
  ),
  MenuItem(
    title: 'Indicadores de progreso',
    subTitle: 'Circulares y lineales, controlados',
    link: '/progress',
    icon: Icons.refresh_rounded,
  ),
  MenuItem(
    title: 'SnackBars y diálogos',
    subTitle: 'Avisos emergentes en pantalla',
    link: '/snackbars',
    icon: Icons.info_outline,
  ),
  MenuItem(
    title: 'Contenedor animado',
    subTitle: 'Tamaño, color y radio animados',
    link: '/animated',
    icon: Icons.animation_rounded,
  ),
  MenuItem(
    title: 'Controles de interfaz',
    subTitle: 'Interruptores, casillas y opciones',
    link: '/ui-controls',
    icon: Icons.tune_rounded,
  ),
  MenuItem(
    title: 'Tutorial',
    subTitle: 'Recorrido introductorio de la app',
    link: '/tutorial',
    icon: Icons.school_outlined,
  ),
  MenuItem(
    title: 'Scroll infinito',
    subTitle: 'Lista con pull to refresh',
    link: '/infinite',
    icon: Icons.view_stream_outlined,
  ),
  MenuItem(
    title: 'Personalizar tema',
    subTitle: 'Modo oscuro y color de acento',
    link: '/tema',
    icon: Icons.palette_outlined,
  ),
];
