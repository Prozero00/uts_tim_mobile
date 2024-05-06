import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_tim_mobile/screen_page/page_gallery.dart';
import 'package:uts_tim_mobile/screen_page/page_list_berita.dart';
import 'package:uts_tim_mobile/screen_page/page_profile.dart';
import 'package:uts_tim_mobile/screen_page/page_register.dart';
import 'package:uts_tim_mobile/screen_page/page_sejarawan.dart';
import 'package:uts_tim_mobile/screen_page/spalshscreen1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _State();
}

class _State extends State<PageHome> with SingleTickerProviderStateMixin {
  late TabController tabController;

  // proses do in background
  // initState : proses di background yang dilakukan sebelum view dipanggil
  // state : proses di background yang dilakukan saat perubahan view
  String? id, fullname, email, tanggal_lahir,jenis_kelamin,alamat,no_hp, password;

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
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: tabController,
        children: const [PageListBerita(), PageGallery(), PageSejarawan(),PageProfile()],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80.1,
        child: TabBar(
            isScrollable: true,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 20),
            controller: tabController,
            tabs: const [
              Tab(
                text: "Home",
                icon: Icon(Icons.house),
              ),
              Tab(
                text: "Gallery",
                icon: Icon(Icons.photo),
              ),
              Tab(
                text: "Sejarawan",
                icon: Icon(Icons.list),
              ),
              Tab(
                text: "Profile",
                icon: Icon(Icons.person),
              )
            ]),
      ),
    );
  }
}
