import 'package:cinemapedia/config/theme/constants/enviroment.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinemapedia'),
      ),
      body: Center(
        child: Text(Environment.theMovieDbKey),
      ),
    );
  }
}   