import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktik/domain/entities/season.dart';

class SeasonTheme {
  final Season season;
  final String name;
  final ColorScheme colorScheme;
  final IconData likeIcon;
  final IconData likeOutlinedIcon;
  final IconData viewsIcon;
  final IconData volumeOnIcon;
  final IconData volumeOffIcon;
  final IconData playIcon;
  final String logoAsset;
  final String audioAsset;
  final String caption;
  final TextTheme Function(TextTheme) applyTypography;

  const SeasonTheme({
    required this.season,
    required this.name,
    required this.colorScheme,
    required this.likeIcon,
    required this.likeOutlinedIcon,
    required this.viewsIcon,
    required this.volumeOnIcon,
    required this.volumeOffIcon,
    required this.playIcon,
    required this.logoAsset,
    required this.audioAsset,
    required this.caption,
    required this.applyTypography,
  });

  ThemeData toMaterialTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
    return base.copyWith(textTheme: applyTypography(base.textTheme));
  }
}

class NormalTheme extends SeasonTheme {
  NormalTheme()
      : super(
          season: Season.normal,
          name: 'Normal',
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6B8CFF),
            secondary: Color(0xFF7B5CFF),
            surface: Color(0xFF101018),
            error: Colors.redAccent,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onError: Colors.white,
          ),
          likeIcon: Icons.favorite,
          likeOutlinedIcon: Icons.favorite_border,
          viewsIcon: Icons.remove_red_eye_outlined,
          volumeOnIcon: Icons.volume_up_rounded,
          volumeOffIcon: Icons.volume_off_rounded,
          playIcon: Icons.play_circle_outline,
          logoAsset: 'assets/logos/vidflow_normal.jpg',
          audioAsset: 'audio/normal.mp3',
          caption: 'VidFlow',
          applyTypography: (base) => GoogleFonts.interTextTheme(base).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );
}

class HalloweenTheme extends SeasonTheme {
  HalloweenTheme()
      : super(
          season: Season.halloween,
          name: 'Halloween',
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF7A18),
            secondary: Color(0xFF6B21A8),
            surface: Color(0xFF12080A),
            error: Color(0xFFFF3B30),
            onPrimary: Colors.black,
            onSecondary: Color(0xFFFFB347),
            onSurface: Color(0xFFFFD7A8),
            onError: Colors.white,
          ),
          likeIcon: Icons.whatshot,
          likeOutlinedIcon: Icons.whatshot_outlined,
          viewsIcon: Icons.visibility_outlined,
          volumeOnIcon: Icons.volume_up_rounded,
          volumeOffIcon: Icons.volume_off_rounded,
          playIcon: Icons.nights_stay_outlined,
          logoAsset: 'assets/logos/vidflow_halloween.jpg',
          audioAsset: 'audio/halloween.mp3',
          caption: 'Halloween',
          applyTypography: (base) {
            try {
              return GoogleFonts.creepsterTextTheme(base).apply(
                bodyColor: const Color(0xFFFFD7A8),
                displayColor: const Color(0xFFFFD7A8),
              );
            } catch (_) {
              return base.apply(
                bodyColor: const Color(0xFFFFD7A8),
                displayColor: const Color(0xFFFFD7A8),
              );
            }
          },
        );
}

class ChristmasTheme extends SeasonTheme {
  ChristmasTheme()
      : super(
          season: Season.christmas,
          name: 'Christmas',
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFC41E3A),
            secondary: Color(0xFF228B22),
            surface: Color(0xFF1A0A0A),
            error: Color(0xFFFFD700),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Color(0xFFFFF5E1),
            onError: Colors.black,
          ),
          likeIcon: Icons.star,
          likeOutlinedIcon: Icons.star_border,
          viewsIcon: Icons.card_giftcard,
          volumeOnIcon: Icons.volume_up_rounded,
          volumeOffIcon: Icons.volume_off_rounded,
          playIcon: Icons.park_outlined,
          logoAsset: 'assets/logos/vidflow_christmas.jpg',
          audioAsset: 'audio/christmas.mp3',
          caption: 'Christmas',
          applyTypography: (base) {
            try {
              return GoogleFonts.mountainsOfChristmasTextTheme(base).apply(
                bodyColor: const Color(0xFFFFF5E1),
                displayColor: const Color(0xFFFFF5E1),
              );
            } catch (_) {
              return base.apply(
                bodyColor: const Color(0xFFFFF5E1),
                displayColor: const Color(0xFFFFF5E1),
              );
            }
          },
        );
}

class ValentineTheme extends SeasonTheme {
  ValentineTheme()
      : super(
          season: Season.valentine,
          name: "Valentine's Day",
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF4D6D),
            secondary: Color(0xFFFF8FAB),
            surface: Color(0xFF2A0A16),
            error: Color(0xFFC9184A),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Color(0xFFFFE5EC),
            onError: Colors.white,
          ),
          likeIcon: Icons.favorite,
          likeOutlinedIcon: Icons.favorite_border,
          viewsIcon: Icons.volunteer_activism_outlined,
          volumeOnIcon: Icons.volume_up_rounded,
          volumeOffIcon: Icons.volume_off_rounded,
          playIcon: Icons.spa_outlined,
          logoAsset: 'assets/logos/vidflow_valentine.jpg',
          audioAsset: 'audio/valentine.mp3',
          caption: "Valentine's Day",
          applyTypography: (base) {
            try {
              return GoogleFonts.greatVibesTextTheme(base).apply(
                bodyColor: const Color(0xFFFFE5EC),
                displayColor: const Color(0xFFFFE5EC),
              );
            } catch (_) {
              return base.apply(
                bodyColor: const Color(0xFFFFE5EC),
                displayColor: const Color(0xFFFFE5EC),
              );
            }
          },
        );
}

class SeasonThemes {
  static SeasonTheme of(Season season) {
    switch (season) {
      case Season.halloween:
        return HalloweenTheme();
      case Season.christmas:
        return ChristmasTheme();
      case Season.valentine:
        return ValentineTheme();
      case Season.normal:
      case Season.auto:
        return NormalTheme();
    }
  }
}
