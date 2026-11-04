import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LayoutPreferences {
  bool get grid;

  /// Saves the grid layout preference
  Future<void> setGrid(bool value);
}

class PreferencesService implements LayoutPreferences {
  /// Creates the layout preferences service
  PreferencesService(this.preferences);
  final SharedPreferences preferences;

  /// Reads the saved grid preference
  @override
  bool get grid => preferences.getBool('catalog.grid') ?? true;

  /// Saves the grid layout preference
  @override
  Future<void> setGrid(bool value) async {
    if (!await preferences.setBool('catalog.grid', value)) {
      throw StateError('Could not save layout preference.');
    }
  }
}
