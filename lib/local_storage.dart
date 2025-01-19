import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  static Future configurePrefs() async =>
      prefs = await SharedPreferences.getInstance();

  static Future<bool> setReward(String name, int rewardIndex) async =>
      await prefs!.setInt(name, rewardIndex);

  static int? getReward() => prefs!.getInt(rewardAccess);

  static Future<bool> cleanReward() async => await prefs!.clear();

  static Future<bool> setLastTimeUsed(int value) async => await prefs!.setInt(lastTimeUsed, value); 

  static int? getLastTimeUsed() => prefs!.getInt(lastTimeUsed);

 static Future<bool> canTryFortune() async {

  final currentDate = DateTime.now();
  final int? lastTime = getLastTimeUsed();

  print("Hoy es ${currentDate.weekday} (Semana ${getWeekOfYear(currentDate)})");

  if (lastTime == null) {
    // Nunca se ha utilizado
    cleanReward();
    return true;
  }

  // Convertir el último uso a DateTime
  final lastDate = DateTime.fromMicrosecondsSinceEpoch(lastTime);

  // Comparar la semana del año y el año
  if (getWeekOfYear(currentDate) != getWeekOfYear(lastDate) ||
      currentDate.year != lastDate.year) {
    cleanReward();
    return true;
  }


  return false;
}

/// Calcula la semana del año para una fecha
static int getWeekOfYear(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysOffset = firstDayOfYear.weekday - DateTime.monday;
  final startOfFirstWeek = firstDayOfYear.subtract(Duration(days: daysOffset));
  final diff = date.difference(startOfFirstWeek).inDays;
  return (diff / 7).ceil();
}
}

const List<String> rewards = [
  "Perdiste :(",
  "50% descuento",
  "Donitas",
  "Perdiste :(",
  "10% descuento",
  "Hot cakes",
];

const String rewardAccess = "cupon";
const String lastTimeUsed = "lastTimeUsed";
