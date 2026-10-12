import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/providers/for_you_provider.dart';

class LikesCoordinator {
  static Future<void> sync(BuildContext context) async {
    final storage = context.read<LocalStorageService>();
    context.read<DiscoverProvider>().syncFromStorage(storage.applyStoredLike);
    context.read<ForYouProvider>().syncFromStorage(storage.applyStoredLike);
    await context.read<FavoritesProvider>().load();
  }
}
