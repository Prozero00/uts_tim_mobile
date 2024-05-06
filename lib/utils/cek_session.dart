
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  int? value;
  String? idUser, fullName,email;

  Future<void> saveSession(int val, String id, String fullName, String email,String no_hp, String jenis_kelamin,String alamat, String tanggal_lahir) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
    pref.setString("fullname", fullName);
    pref.setString("email", email);
    pref.setString("alamat", alamat);
    pref.setString("jenis_kelamin", jenis_kelamin);
    pref.setString("no_hp", no_hp);
    pref.setString("tanggal_lahir", tanggal_lahir);
  }

  Future getSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id");
    pref.getString("fullname");
    pref.getString("email");
    pref.getString("jenis_kelamin");
    pref.getString("alamat");
    pref.getString("no_hp");
    pref.getString("tanggal_lahir");
    return value;
  }

  Future getSesiIdUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("id");
    return idUser;
  }

  //clear session --> logout
  Future clearSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();