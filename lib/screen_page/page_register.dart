import 'package:http/http.dart' as http;
import 'package:uts_tim_mobile/screen_page/page_login.dart';
import 'package:uts_tim_mobile/screen_page/spalshscreen1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/model_register.dart';

class PageRegister extends StatefulWidget {
  const PageRegister({super.key});

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  bool varBool = true;

  TextEditingController txtFullname = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //fungsi untuk post data
  bool isLoading = false;

  Future<ModelRegister?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
          Uri.parse('http://localhost/uts_tim_mobile/register.php'),
          body: {
            "fullname": txtFullname.text,
            "email": txtEmail.text,
            "password": txtPassword.text,
          });
      ModelRegister data = modelRegisterFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          //pindah ke page login
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PageLogin()),
              (route) => false);
        });
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
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
        child: Container(
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
                              builder: (context) => SplashScreen()),
                        );
                      },
                      icon:
                          Icon(Icons.arrow_back_ios, color: Color(0xff828282)),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        'MinangCultura', // Ubah gambar menjadi teks
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
                        controller: txtFullname,
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
                          hintText: 'Full Name',
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                          hintText: 'Email',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: txtPassword,
                        validator: (val) {
                          return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Color(0xFF9E9E9E).withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          hintText: 'Password',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (val) {
                          return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Color(0xFF9E9E9E).withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          hintText: 'Confirm Password',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: varBool,
                            onChanged: (value) {
                              setState(() {
                                varBool = value!;
                              });
                            },
                          ),
                          Text('I agree to the terms and conditions'),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      MaterialButton(
                        onPressed: () {
                          registerAccount();
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 175, vertical: 15),
                        color: Color(0xff561C24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xffF2F2F2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        '-------------------------------------- or -----------------------------',
                        style: TextStyle(
                          color: Color(0xFF561C24),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF561C24)),
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
                              'Sign Up with Google',
                              style: TextStyle(
                                color: Color.fromARGB(255, 244, 242, 242),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 65,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Do you have an account?  ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign In",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageLogin()),
                                  );
                                },
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
