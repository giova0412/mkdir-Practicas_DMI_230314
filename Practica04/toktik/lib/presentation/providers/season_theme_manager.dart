import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/theme/season_resolver.dart';
import 'package:toktik/config/theme/season_themes.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

class SeasonThemeManager extends ChangeNotifier {
  final LocalStorageService _storage;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Season _selectedMode = Season.auto;
  bool _audioEnabled = false;
  bool get isThemeAudioPlaying => _audioEnabled;

  SeasonThemeManager(this._storage) {
    _selectedMode = _storage.getSeasonMode();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.setVolume(0.22);
    // NO autoplay al iniciar (el usuario pidió música solo al cambiar tema).
  }

  Season get selectedMode => _selectedMode;

  Season get resolvedSeason {
    if (_selectedMode == Season.auto) {
      return SeasonResolver.resolveByCurrentDate();
    }
    return _selectedMode;
  }

  SeasonTheme get currentTheme => SeasonThemes.of(resolvedSeason);

  ThemeData get materialTheme => currentTheme.toMaterialTheme();

  Future<void> setMode(Season season) async {
    _selectedMode = season;
    await _storage.setSeasonMode(season);
    // Música SOLO al cambiarlo manualmente (no al abrir la app).
    _audioEnabled = true;
    await _playSeasonAudio();
    notifyListeners();
  }

  Future<void> resetToAuto() => setMode(Season.auto);

  /// Botón de la AppBar: prende/apaga la música del tema actual.
  Future<void> toggleThemeAudio() async {
    if (_audioEnabled) {
      _audioEnabled = false;
      try {
        await _audioPlayer.stop();
      } catch (_) {}
    } else {
      _audioEnabled = true;
      await _playSeasonAudio();
    }
    notifyListeners();
  }

  Future<void> stopThemeAudio() async {
    _audioEnabled = false;
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _playSeasonAudio() async {
    if (!_audioEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(currentTheme.audioAsset));
    } catch (_) {
      // El audio es ambientación; no debe tumbar la app.
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
