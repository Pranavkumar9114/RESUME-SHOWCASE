import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static final AppState _instance = AppState._internal();

  bool extractionDone = false;

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    extractionDone = prefs.getBool('extractionDone') ?? false;
  }

  Future<void> saveExtractionDone(bool done) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('extractionDone', done);
    extractionDone = done;
  }
}
