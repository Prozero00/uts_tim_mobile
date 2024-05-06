import 'package:http/http.dart' as http;
import 'package:uts_tim_mobile/main.dart';
import 'package:uts_tim_mobile/screen_page/page_register.dart';
import 'package:uts_tim_mobile/screen_page//spalshscreen1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/model_login.dart';
import '../utils/cek_session.dart';


class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //fungsi untuk post data
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async{
    try{
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('http://localhost/uts_tim_mobile/login.php'),
          body: {
            "email" : txtEmail.text,
            "password" : txtPassword.text,

          }
      );
      ModelLogin data = modelLoginFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value ,1 (ada data login),dan 0 (gagal)
      if(data.value == 1){
        setState(() {
          //save session
          session.saveSession(data.value ?? 0, data.idUser ?? "", data.fullname ?? "", data.email ?? "",data.jenisKelamin ?? "", data.noHp ?? "",data.alamat ?? "", data.tanggalLahir ?? "",);

          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );

          //pindah ke page berita
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context)
              => const PageHome()), (route) => false);
        });
      }else{
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
        });
      }

    }catch(e){
      //munculkan error
      setState(() {
        isLoading= false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC7B7A3),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.topLeft,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff828282),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                    ),
                    Text(
                      'MinangCultura', // Ganti dengan teks yang diinginkan
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF803D3B),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    TextFormField(
                      controller: txtEmail,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          hintText: 'Email'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MaterialButton(
                      onPressed: () {
                        loginAccount();
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 175, vertical: 15),
                      color: Color(0xFF561C24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xffF2F2F2)),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '-------------------------------------- or -----------------------------',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PageHome(),));
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            '../gambar/gambar2.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                                color: Color(0xff828282),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 65,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Don't have an account?  ",
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PageRegister()));
                                  },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
