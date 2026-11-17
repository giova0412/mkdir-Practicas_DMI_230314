import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/config/theme/app_theme.dart';

/// Expone la paleta de colores disponibles en la app.
final paletaProvider = Provider<List<Color>>((ref) => paletaColores);

/// Estado global del tema (modo oscuro + color de acento).
final temaNotifierProvider = StateNotifierProvider<TemaNotifier, AppTheme>(
  (ref) => TemaNotifier(),
);

class TemaNotifier extends StateNotifier<AppTheme> {
  TemaNotifier() : super(AppTheme());

  /// Alterna entre modo claro y oscuro.
  void alternarModoOscuro() =>
      state = state.copyWith(modoOscuro: !state.modoOscuro);

  /// Cambia el color de acento por su índice en la paleta.
  void cambiarIndiceColor(int indice) =>
      state = state.copyWith(indiceColor: indice);
}
