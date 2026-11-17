import 'package:flutter/material.dart';

/// Paleta propia de "Caja de Widgets".
///
/// El orden y los tonos son distintos a los del proyecto de clase para dar
/// una identidad visual propia a esta práctica.
const paletaColores = <Color>[
  Color(0xFF00695C), // verde azulado profundo
  Color(0xFF283593), // azul índigo
  Color(0xFF00838F), // cian oscuro
  Color(0xFF6A1B9A), // violeta
  Color(0xFFEF6C00), // naranja intenso
  Color(0xFFAD1457), // frambuesa
  Color(0xFF2E7D32), // verde bosque
  Color(0xFF37474F), // gris pizarra
];

class AppTheme {
  final int indiceColor;
  final bool modoOscuro;

  AppTheme({this.indiceColor = 0, this.modoOscuro = false})
      : assert(indiceColor >= 0, 'El índice de color no puede ser negativo'),
        assert(
          indiceColor < paletaColores.length,
          'El índice debe ser menor o igual a ${paletaColores.length - 1}',
        );

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: modoOscuro ? Brightness.dark : Brightness.light,
        colorSchemeSeed: paletaColores[indiceColor],
        appBarTheme: const AppBarTheme(centerTitle: false),
      );

  AppTheme copyWith({int? indiceColor, bool? modoOscuro}) => AppTheme(
        indiceColor: indiceColor ?? this.indiceColor,
        modoOscuro: modoOscuro ?? this.modoOscuro,
      );
}
