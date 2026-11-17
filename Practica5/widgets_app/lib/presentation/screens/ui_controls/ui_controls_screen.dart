import 'package:flutter/material.dart';

class UiControlsScreen extends StatefulWidget {
  static const String name = 'ui_controls_screen';

  const UiControlsScreen({super.key});

  @override
  State<UiControlsScreen> createState() => _UiControlsScreenState();
}

class _UiControlsScreenState extends State<UiControlsScreen> {
  bool switchNotificaciones = true;
  bool checkWifi = false;
  bool checkDatos = true;
  String? turno = 'matutino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controles de interfaz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const _Seccion('Interruptores'),
          SwitchListTile(
            title: const Text('Notificaciones'),
            subtitle: Text(switchNotificaciones ? 'Activadas' : 'Desactivadas'),
            value: switchNotificaciones,
            onChanged: (v) => setState(() => switchNotificaciones = v),
          ),
          const Divider(),
          const _Seccion('Casillas de verificación'),
          CheckboxListTile(
            title: const Text('Wi-Fi'),
            value: checkWifi,
            onChanged: (v) => setState(() => checkWifi = v ?? false),
          ),
          CheckboxListTile(
            title: const Text('Datos móviles'),
            value: checkDatos,
            onChanged: (v) => setState(() => checkDatos = v ?? false),
          ),
          const Divider(),
          const _Seccion('Opciones de selección'),
          RadioGroup<String>(
            groupValue: turno,
            onChanged: (v) => setState(() => turno = v),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Matutino'),
                  value: 'matutino',
                ),
                RadioListTile<String>(
                  title: const Text('Vespertino'),
                  value: 'vespertino',
                ),
              ],
            ),
          ),
          const Divider(),
          const _Seccion('Resumen'),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            trailing: Text(switchNotificaciones ? 'Sí' : 'No'),
          ),
          ListTile(
            leading: const Icon(Icons.wifi),
            title: const Text('Wi-Fi'),
            trailing: Text(checkWifi ? 'Sí' : 'No'),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Turno'),
            trailing: Text(turno ?? 'Sin definir'),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;

  const _Seccion(this.titulo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        titulo.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
