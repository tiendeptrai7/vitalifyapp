
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';



class SharedPreferenceHelper {


  SharedPreferences? prefs;

  Future _accessSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future get(key) async {
    await _accessSharedPrefs();
    try {
      return json.decode(prefs!.get(key) as String);
    } catch (e) {
      return prefs!.get(key);
    }
  }
  Future destroy() async {
    await _accessSharedPrefs();
    try {
      await prefs!.clear();
    } catch (e) {
      throw Exception(
          "It wasn't possible to destroy the session. This can be triggered if the session no longer exists or if the session is inaccessible. ");
    }
  }



  Future set(key, value) async {
    await _accessSharedPrefs();
    try {
      // Detect item type
      switch (value.runtimeType) {
      // String
        case String:
          {
            prefs!.setString(key, value);
          }
          break;


      // Bool
        case bool:
          {
            prefs!.setBool(key, value);
          }
          break;
      }
    } catch (e) {
      throw Exception("Key or value are not the correct type.");
    }

  }


}
