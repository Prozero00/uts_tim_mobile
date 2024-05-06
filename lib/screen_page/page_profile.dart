import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_tim_mobile/screen_page/edit_profile.dart';
import 'package:uts_tim_mobile/screen_page/page_login.dart';

import '../utils/cek_session.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  String? id,
      fullname,
      email,
      tanggal_lahir,
      jenis_kelamin,
      alamat,
      no_hp,
      password;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      fullname = pref.getString("fullname") ?? '';
      email = pref.getString("email") ?? '';
      print('id $id');
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7B7A3),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Color(0xffC7B7A3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.brown,
                    // backgroundImage: AssetImage('images/user.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      fullname?.isNotEmpty == true ? fullname!: '?',
                      style: const TextStyle(fontSize: 36, color: Colors.black),
                    ),
                    Text(
                      email?.isNotEmpty == true ? email! : '?',
                      style: const TextStyle(fontSize: 36, color: Colors.brown),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PageUpdateUser(
                      onProfileUpdate: (String newFullName,
                          String newTglLahir,
                          String newJenisKelamin,
                          String newNoHp,
                          String newEmail,
                          String newAlamat,
                          String newPassword) {
                        // Implement the logic to update the profile with the new data
                        setState(() {
                          fullname = newFullName;
                          email = newEmail;
                          tanggal_lahir = newTglLahir;
                          no_hp = newNoHp;
                          jenis_kelamin = newJenisKelamin;
                          alamat = newAlamat;
                          password = newPassword;
                          // You may or may not want to update the password based on your application's requirements
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text("Ubah Profil"),
              color: Colors.white,
              textColor: Colors.black,
              height: 32,
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: Container(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Data Pribadi \n"),
                      SizedBox(height: 5,),
                      Text("Nama Lengkap \n${fullname} \n---------------------------------------------------------------"),
                      SizedBox(height: 5,),
                      Text("Tanggal Lahir \n${tanggal_lahir} \n---------------------------------------------------------------"),
                      SizedBox(height: 5,),
                      Text("Jenis Kelamin \n${jenis_kelamin} \n---------------------------------------------------------------"),
                      SizedBox(height: 5,),
                      Text("No HP \n${no_hp} \n---------------------------------------------------------------"),
                      SizedBox(height: 5,),
                      Text("Alamat \n${alamat} \n---------------------------------------------------------------"),
                      SizedBox(height: 5,),
                      Text("Email \n${email} \n---------------------------------------------------------------"),
                      SizedBox(height: 20,),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            session.clearSession();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageLogin(),
                                ));
                          },
                          child: Text("Logout"),
                          color: Colors.brown,
                          textColor: Colors.white,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
