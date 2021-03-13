import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  
  String gid = 'NotDefine';

  Future<Null> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gid = prefs.getString('gid') ?? 'None';
    notifyListeners();
  }

  void saveGID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (id != '') {
      gid = id;
      await prefs.setString('gid', id);

      notifyListeners();
    }
  }
}
