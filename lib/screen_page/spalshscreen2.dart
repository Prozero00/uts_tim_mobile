import 'dart:ui';


import 'package:uts_tim_mobile/screen_page/spalshscreen3.dart';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.0),
            Text(
              'MinangCultura',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF803D3B),
              ),
            ),
            SizedBox(height: 50.0),
            Image.asset('../gambar/gambar3.png'), // Replace 'assets/logo.png' with the actual path to your image
            SizedBox(height: 30.0),
            Text(
              'Selamat Datang',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF803D3B),
              ),
            ),
            SizedBox(height: 90.0),
            Image.asset('../gambar/gambar4.png'),
            SizedBox(height: 65),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen3()),
                );
              },
              padding: EdgeInsets.symmetric(horizontal: 175, vertical: 15),
              color: Color(0xff561C24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                'Selanjutnya',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xffF2F2F2),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFC7B7A3),
    );
  }
}
