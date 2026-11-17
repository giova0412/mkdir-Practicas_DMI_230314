import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets_app/config/menu/menu_items.dart';

class MenuLateral extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MenuLateral({super.key, required this.scaffoldKey});

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  int indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    final tieneNotch = MediaQuery.of(context).viewPadding.top > 35;

    return NavigationDrawer(
      selectedIndex: indiceSeleccionado,
      onDestinationSelected: (indice) {
        setState(() => indiceSeleccionado = indice);
        context.push(appMenuItems[indice].link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, tieneNotch ? 0 : 20, 16, 10),
          child: const Text(
            'Caja de Widgets',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...appMenuItems.sublist(0, 6).map(
              (item) => NavigationDrawerDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              ),
            ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('Más demos'),
        ),
        ...appMenuItems.sublist(6).map(
              (item) => NavigationDrawerDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              ),
            ),
      ],
    );
  }
}
