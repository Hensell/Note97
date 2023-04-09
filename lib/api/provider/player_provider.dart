import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PlayerProvider with ChangeNotifier {
  final String soundPreferenceKey = 'sound_preference';
  final String soundActivePreferenceKey = 'active_sound';
  final AudioPlayer _soundProvider = AudioPlayer();

  AudioPlayer get soundProvider => _soundProvider;

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themePreference = prefs.getInt(soundPreferenceKey) ?? 0;
    setSelectedSounds(themePreference);
  }

  setPref(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(soundPreferenceKey, value);
  }

  Future<bool> getSoundPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool themePreference = prefs.getBool(soundActivePreferenceKey) ?? false;

    return themePreference;
  }

  setSoundPref(bool active) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(soundActivePreferenceKey, active);
  }

  PlayerProvider() {
    getPref();
  }
  playSound() async {
    if (await getSoundPref()) {
      await getPref();
      _soundProvider.play(_soundProvider.source!);
    }
  }

  void setSelectedSounds(int value) async {
    switch (value) {
      case 0:
        getNight();

        break;

      case 1:
        getKawaii();
        break;

      case 2:
        getKawaii();
        break;

      case 3:
        get8Bit();
        break;
      default:
        getNight();
    }
    notifyListeners();
    setPref(value);
  }

  getNight() async {
    await _soundProvider.setSource(AssetSource('sounds/night/night.mp3'));
  }

  getKawaii() async {
    await _soundProvider.setSource(AssetSource('sounds/kawaii/kawaii.mp3'));
  }

  get8Bit() async {
    await _soundProvider.setSource(AssetSource('sounds/8bit/8bit.mp3'));
  }
}
