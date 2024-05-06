import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/model_sejarawan.dart';

class PageGallery extends StatefulWidget {
  const PageGallery({super.key});

  @override
  State<PageGallery> createState() => _PageGalleryState();
}

class _PageGalleryState extends State<PageGallery> {
  late Future<List<Datum>?> _beritaFuture;
  List<Datum> listBerita = [];
  List<Datum> filteredBerita = [];
  String? id, username;
  TextEditingController txtCari = TextEditingController();
  bool isLoading = false;

  //  id = session.getSesiIdUser();
  //fungsion untuk get data berita
  Future<List<Datum>?> getBerita() async {
    try {
      http.Response res =
          await http.get(Uri.parse('http://localhost/uts_tim_mobile/listsejarawan.php'));
      return modelSejarawanFromJson(res.body).data;
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  void filterBerita(String query) {
    setState(() {
      filteredBerita = listBerita
          .where((berita) =>
              berita.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      print('id $id');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
    _beritaFuture = getBerita();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffC7B7A3),
        appBar: AppBar(
          backgroundColor: Color(0xffB57371),
          title: Center(child: Text('Galeri Foto MinangCultura',)),
        ),
        body: FutureBuilder<List<Datum>?>(
                future: _beritaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(color: Colors.orange));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    listBerita = snapshot.data!;
                    if (filteredBerita.isEmpty) {
                      filteredBerita = listBerita;
                    }
                    return ListView.builder(
                      itemCount: filteredBerita.length,
                      itemBuilder: (context, index) {
                        Datum data = filteredBerita[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 10),
                            child: Card(
                              color:Color(0xffF3DBDA),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Center(
                                        child: Image.network(
                                          'http://localhost/uts_tim_mobile/image/${data.foto}',
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Text('Image not available'));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            );

  }
}
