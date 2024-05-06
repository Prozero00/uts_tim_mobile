import 'dart:ui';

import 'package:uts_tim_mobile/screen_page/page_login.dart';
import 'package:flutter/material.dart';

class SplashScreen3 extends StatefulWidget {
  @override
  _SplashScreen3State createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> {
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
            SizedBox(height: 40.0),
            Image.asset('../gambar/gambar3.png'), // Replace 'assets/logo.png' with the actual path to your image
            SizedBox(height: 23.0),
            Text(
              '"Tembus batas budaya dengan setiap sentuhan.'
               '\nSelamat datang di dunia yang mempesona dari'
               '\n kebudayaan Minangkabau.Mulailah petualanganmu'
               '\n dan temukan keindahan yang tak terlupakan."',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Color(0xFF803D3B),
              ),
            ),
            SizedBox(height: 90.0),
            Image.asset('../gambar/gambar5.png'),
            SizedBox(height: 60),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PageLogin()),
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
