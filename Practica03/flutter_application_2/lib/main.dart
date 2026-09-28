import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/config/theme/app_theme.dart';
import 'package:flutter_application_2/presentation/chat/chat_screen.dart';
import 'package:flutter_application_2/presentation/providers/chat_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: MaterialApp(
        title: 'Yes No App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 2).theme(),
        home: const ChatScreen(),
      ),
    );
  }
}
