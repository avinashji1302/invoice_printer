import 'package:app/core/database/app_database.dart';
import 'package:flutter/foundation.dart';

class PremiumController {
  static bool _isPremium = false;

  static bool get isPremium => _isPremium;

  static void setPremium(bool val) {
    _isPremium = val;
  }
}


Future<void> loadPremiumStatus() async {
 final AppDatabase _database = AppDatabase();

  final db = await _database.database;

  final result = await db.query("settings");

  if(result.isNotEmpty && result.first["premium"] == 1){
    PremiumController.setPremium(true);
  } else {
    // PremiumController.setPremium(false);
     PremiumController.setPremium(true);

     debugPrint("inside : true;");
  }

}