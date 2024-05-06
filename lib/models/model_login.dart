// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  int value;
  String message;
  String fullname;
  String tanggalLahir;
  String jenisKelamin;
  String noHp;
  String email;
  String alamat;
  String idUser;

  ModelLogin({
    required this.value,
    required this.message,
    required this.fullname,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.noHp,
    required this.email,
    required this.alamat,
    required this.idUser,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
    value: json["value"],
    message: json["message"],
    fullname: json["fullname"],
    tanggalLahir: json["tanggal_lahir"],
    jenisKelamin: json["jenis_kelamin"],
    noHp: json["no_hp"],
    email: json["email"],
    alamat: json["alamat"],
    idUser: json["id_user"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "fullname": fullname,
    "tanggal_lahir": tanggalLahir,
    "jenis_kelamin": jenisKelamin,
    "no_hp": noHp,
    "email": email,
    "alamat": alamat,
    "id_user": idUser,
  };
}
