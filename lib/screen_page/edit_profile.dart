import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_tim_mobile/models/ModelEditUser.dart';
import 'package:uts_tim_mobile/utils/cek_session.dart';

class PageUpdateUser extends StatefulWidget {
  final Function(String, String, String, String, String, String, String)
      onProfileUpdate;

  const PageUpdateUser({Key? key, required this.onProfileUpdate})
      : super(key: key);

  @override
  _PageUpdateUserState createState() => _PageUpdateUserState();
}

class _PageUpdateUserState extends State<PageUpdateUser> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();
  TextEditingController _jenisKelaminController = TextEditingController();
  TextEditingController _noHpController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? id, fullname, email,tanggal_lahir,alamat,jenis_kelamin,no_hp;

  bool isLoading = false;
  bool isPasswordVisible = false;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      fullname = pref.getString("fullname") ?? '';
      email = pref.getString("email") ?? '';
      jenis_kelamin = pref.getString("jenis_kelamin") ?? '';
      alamat = pref.getString("alamat") ?? '';
      no_hp = pref.getString("no_hp") ?? '';
      tanggal_lahir = pref.getString("tanggal_lahir") ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<ModelEditUser?> editProfile() async {
    try {
      bool confirmAction = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to save changes?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );

      if (confirmAction == true) {
        setState(() {
          isLoading = true;
        });

        http.Response res = await http.post(
          Uri.parse('http://localhost/uts_tim_mobile/updateUser.php'),
          body: {
            "id_user": id ?? '',
            "fullname": _fullNameController.text,
            "tanggal_lahir": _tglLahirController.text,
            "jenis_kelamin": _jenisKelaminController.text,
            "email": _emailController.text,
            "alamat": _alamatController.text,
            "no_hp": _noHpController.text,
            "password": _passwordController.text,
          },
        );

        ModelEditUser data = modelEditUserFromJson(res.body);
        if (data.value == 1) {
          widget.onProfileUpdate(
            _fullNameController.text,
            _tglLahirController.text,
            _jenisKelaminController.text,
            _noHpController.text,
            _emailController.text,
            _alamatController.text,
            _passwordController.text,
          );
          setState(() {
            session.saveSession(data.value ?? 0, data.idUser ?? "", data.fullname ?? "", data.email ?? "",data.jenisKelamin ?? "", data.noHp ?? "",data.alamat ?? "", data.tanggalLahir ?? "",);
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data.message)));
            Navigator.pop(context);
          });
        } else {
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data.message)));
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Fullname',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _fullNameController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tglLahirController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _tglLahirController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _jenisKelaminController,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _jenisKelaminController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noHpController,
                decoration: InputDecoration(
                  labelText: 'No HP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _noHpController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _emailController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _alamatController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                obscureText: !isPasswordVisible,
              ),
              const SizedBox(height: 10),
              // Add similar TextFormField widgets for other fields
              // ...
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          editProfile();
                        }
                      },
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
