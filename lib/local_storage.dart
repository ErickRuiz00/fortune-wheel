// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorage {
//   static SharedPreferences? prefs;

//   static Future configurePrefs() async =>
//       prefs = await SharedPreferences.getInstance();

//   static Future<bool> setString(PreferencesString name, String data) async =>
//       await prefs!.setString(name.value, data);
// }

// enum PreferencesString {
//   cupon("cupon");

//   final String value;
//   const PreferencesString(this.value);
// }

// enum Rewards {
//   hotCakes("Hot cakes"),
//   waffles("Waffles"),
//   donuts("Donitas"),

// }
