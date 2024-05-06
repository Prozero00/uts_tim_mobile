// To parse this JSON data, do
//
//     final modelEditUser = modelEditUserFromJson(jsonString);

import 'dart:convert';

ModelEditUser modelEditUserFromJson(String str) => ModelEditUser.fromJson(json.decode(str));

String modelEditUserToJson(ModelEditUser data) => json.encode(data.toJson());

class ModelEditUser {
    bool isSuccess;
    int value;
    String message;
    String fullname;
    String noHp;
    String alamat;
    String tanggalLahir;
    String jenisKelamin;
    String email;
    String password;
    String idUser;

    ModelEditUser({
        required this.isSuccess,
        required this.value,
        required this.message,
        required this.fullname,
        required this.noHp,
        required this.alamat,
        required this.tanggalLahir,
        required this.jenisKelamin,
        required this.email,
        required this.password,
        required this.idUser,
    });

    factory ModelEditUser.fromJson(Map<String, dynamic> json) => ModelEditUser(
        isSuccess: json["is_success"],
        value: json["value"],
        message: json["message"],
        fullname: json["fullname"],
        noHp: json["no_hp"],
        alamat: json["alamat"],
        tanggalLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        email: json["email"],
        password: json["password"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "value": value,
        "message": message,
        "fullname": fullname,
        "no_hp": noHp,
        "alamat": alamat,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "email": email,
        "password": password,
        "id_user": idUser,
    };
}
