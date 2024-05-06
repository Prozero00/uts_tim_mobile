import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this import
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_tim_mobile/main.dart';
import 'package:uts_tim_mobile/models/model_add_sejarawan.dart';
import 'package:uts_tim_mobile/screen_page/page_list_berita.dart';

import '../models/model_sejarawan.dart';
import '../utils/cek_session.dart';

class PageSejarawan extends StatefulWidget {
  const PageSejarawan({super.key});

  @override
  State<PageSejarawan> createState() => _PageSejarawanState();
}

class _PageSejarawanState extends State<PageSejarawan> {
  late Future<List<Datum>?> _sejarawanFuture;
  List<Datum> listSejarawan = [];
  List<Datum> filteredSejarawn = [];
  String? id, username;
  TextEditingController txtCari = TextEditingController();
  bool isLoading = false;

  //  id = session.getSesiIdUser();
  //fungsion untuk get data berita
  Future<List<Datum>?> getSejarawan() async {
    try {
      http.Response res = await http
          .get(Uri.parse('http://localhost/uts_tim_mobile/listsejarawan.php'));
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
      filteredSejarawn = listSejarawan
          .where((sejarawan) =>
              sejarawan.nama.toLowerCase().contains(query.toLowerCase()))
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

  Future deleteSejarawan(String id) async {
    try {
      http.Response response = await http
          .post(Uri.parse('http://localhost/uts_tim_mobile/hapus.php'), body: {
        "id": id,
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
    _sejarawanFuture = getSejarawan();
    getSejarawan().then((Sejarawans) {
      setState(() {
        listSejarawan = Sejarawans!;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7B7A3),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: txtCari,
              onChanged: (query) {
                filterBerita(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Color(0xffB57371),
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _sejarawanFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.orange));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  listSejarawan = snapshot.data!;
                  if (filteredSejarawn.isEmpty) {
                    filteredSejarawn = listSejarawan;
                  }
                  return ListView.builder(
                    itemCount: filteredSejarawn.length,
                    itemBuilder: (context, index) {
                      Datum data = filteredSejarawn[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PageDetailSejarawan(data)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color(0xffF3DBDA),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Image.network(
                                        'http://localhost/uts_tim_mobile/image/${data?.foto}' ??
                                            '',
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child:
                                                  Text('Image not available'));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Column(
                                    children: [
                                      Text(
                                        data.nama ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            data?.tglLahir ?? "",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            data.asal ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    data.deskripsi ?? '',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PageUpdateMahasiswa(data)),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Text('Hapus data ?',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    deleteSejarawan(
                                                            data.idSejarawan)
                                                        .then((value) {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Hapus'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    getSejarawan();
                                                  },
                                                  child: Text('Batal'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                )
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageInsertSejarawan()),
          );
        },
      ),
    );
  }
}

class PageInsertSejarawan extends StatefulWidget {
  const PageInsertSejarawan({Key? key}) : super(key: key);

  @override
  State<PageInsertSejarawan> createState() => _PageInsertSejarawanState();
}

class _PageInsertSejarawanState extends State<PageInsertSejarawan> {
  TextEditingController nama = TextEditingController();
  TextEditingController tanggal_lahir = TextEditingController();
  TextEditingController asal = TextEditingController();
  TextEditingController jenis_kelamin = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  XFile? _imageFile; // Variable to store the selected image file

  bool isLoading = false;

  Future<ModelAddSejarawan?> createSejarawan() async {
    try {
      // Read image file as bytes
      Uint8List bytes = await _imageFile!.readAsBytes();
      // Convert bytes to base64 string
      String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("http://localhost/uts_tim_mobile/addsejarawan.php"),
        body: {
          "nama": nama.text,
          "tgl_lahir": tanggal_lahir.text,
          "asal": asal.text,
          "jenis_kelamin": jenis_kelamin.text,
          "deskripsi": deskripsi.text,
          "foto": base64Image, // Include the base64 string of the image
        },
      );

      if (response.statusCode == 200) {
        final data = modelAddSejarawanFromJson(response.body);
        if (data.message == "success") {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return data;
      } else {
        throw Exception('Gagal menambahkan data sejarawan');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Gagal menambahkan data sejarawan",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return null;
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? XFile(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7B7A3),
      appBar: AppBar(
        backgroundColor: Color(0xffB57371),
        title: Text(
          'Tambah Sejarawan',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: nama,
                validator: (val) =>
                    val!.isEmpty ? "Nama tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Nama Sejarawan",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: tanggal_lahir,
                validator: (val) =>
                    val!.isEmpty ? "Tanggal tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Tanggal Lahir",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: asal,
                validator: (val) =>
                    val!.isEmpty ? "Asal tidak boleh kosong!" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Asal",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: jenis_kelamin,
                validator: (val) =>
                    val!.isEmpty ? "Email can't be empty" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Jenis Kelamin",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: deskripsi,
                validator: (val) =>
                    val!.isEmpty ? "Deskripsi tidak boleh kosong!" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Deskripsi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              MaterialButton(
                minWidth: 150,
                height: 45,
                color: Color(0xff561C24).withOpacity(0.3),
                textColor: Colors.white,
                onPressed: _pickImageFromGallery,
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 25),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        minWidth: 150,
                        height: 45,
                        color: Colors.brown,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (_imageFile != null &&
                              keyForm.currentState!.validate()) {
                            await createSejarawan(); // Wait for createSejarawan to complete
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageHome(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Mohon pilih gambar"),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageDetailSejarawan extends StatelessWidget {
  final Datum? data;

  const PageDetailSejarawan(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7B7A3),
      appBar: AppBar(
        title: Text('Detail Sejarawan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xffB57371),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          'http://localhost/uts_tim_mobile/image/${data?.foto}' ??
                              '',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Image not available'));
                      }),
                    ),
                  ),
                ),
                Text(
                  '${data?.nama}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${data?.tglLahir}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${data?.deskripsi}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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

class PageUpdateMahasiswa extends StatefulWidget {
  final Datum data;

  const PageUpdateMahasiswa(this.data, {super.key});

  @override
  State<PageUpdateMahasiswa> createState() => _PageUpdateMahasiswaState();
}

class _PageUpdateMahasiswaState extends State<PageUpdateMahasiswa> {
  TextEditingController id_sejarawan = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController tgl_lahir = TextEditingController();
  TextEditingController asal = TextEditingController();
  TextEditingController jenis_kelamin = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  XFile? _imageFile;

  bool isLoading = false;

  Future updateSejarawan() async {
    // Read image file as bytes
    Uint8List bytes = await _imageFile!.readAsBytes();
    // Convert bytes to base64 string
    String base64Image = base64Encode(bytes);

    final res = await http.post(
      Uri.parse("http://localhost/uts_tim_mobile/updateSejarawan.php"),
      body: {
        "id_sejarawan": id_sejarawan.text,
        // Pass the id of the employee to update
        "nama": nama.text,
        "foto": base64Image,
        "tgl_lahir": tgl_lahir.text,
        "jenis_kelamin": jenis_kelamin.text,
        "deskripsi": deskripsi.text,
      },
    );

    if (res.statusCode == 200) {
      Navigator.pop(
        context,
      );
    }
    return false;
  }


  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? XFile(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    id_sejarawan.text = widget.data.idSejarawan;
    nama.text = widget.data.nama;
    tgl_lahir.text = widget.data.tglLahir;
    asal.text = widget.data.asal;
    jenis_kelamin.text = widget.data.jenisKelamin;
    deskripsi.text = widget.data.deskripsi;
    return Scaffold(
      backgroundColor: Color(0xffC7B7A3),
      appBar: AppBar(
        backgroundColor: Color(0xffB57371),
        title: Text('Update Sejarawan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: nama,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Nama",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: tgl_lahir,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Tanggal Lahir",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: asal,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Asal",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: jenis_kelamin,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Jenis Kelamin",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: deskripsi,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Deskripsi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              MaterialButton(
                minWidth: 150,
                height: 45,
                color: Color(0xff561C24).withOpacity(0.3),
                textColor: Colors.white,
                onPressed: _pickImageFromGallery,
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 25),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        minWidth: 150,
                        height: 45,
                        color: Colors.brown,
                        onPressed: () {
                          updateSejarawan();
                        },
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
