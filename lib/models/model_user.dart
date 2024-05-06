// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

ModelUser modelUserFromJson(String str) => ModelUser.fromJson(json.decode(str));

String modelUserToJson(ModelUser data) => json.encode(data.toJson());

class ModelUser {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelUser({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String idUser;
    String fullname;
    String tanggalLahir;
    String jenisKelamin;
    //String username;
    //String password;
    String nohp;
    //String nim;
    String email;
    String alamat;
    //DateTime created;
    dynamic updated;

    Datum({
        required this.idUser,
        required this.fullname,
        required this.tanggalLahir,
        required this.jenisKelamin,
        //required this.username,
        //required this.password,
        required this.nohp,
        //required this.nim,
        required this.email,
        required this.alamat,
        //required this.created,
        required this.updated,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idUser: json["id_user"],
        fullname: json["fullname"],
        tanggalLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        //username: json["username"],
        //password: json["password"],
        nohp: json["nohp"],
        //nim: json["nim"],
        email: json["email"],
        alamat: json["alamat"],
        //created: DateTime.parse(json["created"]),
        updated: json["updated"],
    );

    Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "fullname": fullname,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        //"username": username,
        //"password": password,
        "nohp": nohp,
        //"nim": nim,
        "email": email,
        "alamat": alamat,
        //"created": created.toIso8601String(),
        "updated": updated,
    };
}
