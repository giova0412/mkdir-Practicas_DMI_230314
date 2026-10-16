import 'package:flutter/material.dart';

class PlaybackController extends ChangeNotifier {
  bool _muted = true;
  String? _activeKey;
  String _activeSection = 'discover';
  int _activeIndex = 0;

  bool get muted => _muted;
  String? get activeKey => _activeKey;
  String get activeSection => _activeSection;
  int get activeIndex => _activeIndex;

  void setActive(String section, int index) {
    _activeSection = section;
    _activeIndex = index;
    _activeKey = '$section-$index';
    notifyListeners();
  }

  void setSection(String section) {
    _activeSection = section;
    _activeIndex = 0;
    _activeKey = '$section-0';
    notifyListeners();
  }

  bool isActive(String section, int index) {
    return _activeKey == '$section-$index';
  }

  void toggleMute() {
    _muted = !_muted;
    notifyListeners();
  }

  bool isUnmuted(String section, int index) {
    return !_muted && _activeKey == '$section-$index';
  }
}
