import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/bird_class.dart';

class SharedPrefStorage {
  late SharedPreferences _prefs;

  List<String> detections = [];

  createPref() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  clear() async {
    await _prefs.clear();
  }

  Future<void> saveBirdsToLocal(BirdModel bird) async {
    detections = getBirdsFromLocal();
    detections.add(
      jsonEncode(
        BirdModel.toJson(bird),
      ),
    );

    await _prefs.setStringList("detections", detections);
    print("Kayıt yapıldı" + detections.toString());
    _prefs.reload();
  }

  List<String> getBirdsFromLocal() {
    _prefs.reload();

    detections = _prefs.getStringList("detections") ?? [];
    print(detections.toString());
    return detections;
  }
}
