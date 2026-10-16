import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/presentation/providers/playback_controller.dart';
import 'package:toktik/presentation/providers/season_theme_manager.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';
import 'package:toktik/presentation/screens/favorites/favorites_screen.dart';
import 'package:toktik/presentation/screens/for_you/for_you_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  static const _sections = ['discover', 'for_you', 'favorites'];

  void _onTabSelected(int value) {
    setState(() => _index = value);
    // Al cambiar de pestaña activa el primer video de esa sección
    // para que el autoplay funcione (antes se quedaba en negro/pausado).
    context.read<PlaybackController>().setSection(_sections[value]);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<SeasonThemeManager>();
    final theme = themeManager.currentTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                theme.logoAsset,
                height: 36,
                width: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'VidFlow · ${theme.caption}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Música del tema: solo suena al cambiarlo o al picarle aquí.
          IconButton(
            tooltip: themeManager.isThemeAudioPlaying
                ? 'Apagar música del tema'
                : 'Encender música del tema',
            icon: Icon(
              themeManager.isThemeAudioPlaying
                  ? Icons.music_note
                  : Icons.music_off_outlined,
            ),
            onPressed: () async {
              await context.read<SeasonThemeManager>().toggleThemeAudio();
              if (context.mounted) {
                final playing =
                    context.read<SeasonThemeManager>().isThemeAudioPlaying;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      playing
                          ? 'Música del tema activada'
                          : 'Música del tema apagada',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<Season>(
            tooltip: 'Temporada',
            initialValue: themeManager.selectedMode,
            onSelected: themeManager.setMode,
            itemBuilder: (context) => Season.values
                .map(
                  (season) => PopupMenuItem(
                    value: season,
                    child: Text(season.label),
                  ),
                )
                .toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(themeManager.selectedMode.label),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          DiscoverScreen(),
          ForYouScreen(),
          FavoritesScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'For You',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
