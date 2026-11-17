import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contador global reactivo. Empieza en 0.
final contadorProvider = StateProvider<int>((ref) => 0);
