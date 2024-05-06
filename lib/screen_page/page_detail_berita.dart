import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/model_berita.dart';

class detailBerita extends StatelessWidget {
  final Datum? data;
  const detailBerita( this.data,{super.key,});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffC7B7A3),
        appBar: AppBar(
          backgroundColor: Color(0xffB57371),
          title: Text(data?.judul ?? "",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
        ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network('http://localhost/uts_tim_mobile/image/${data?.gambar}',
                fit: BoxFit.fill,
              ),

            ),
          ),
          ListTile(
            title: Text(data?.judul ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),
            subtitle: Row(
              children: [
                Text(DateFormat().format(data?.created ?? DateTime.now())),
                SizedBox(width: 20,),
                Text(data?.author ?? ""),
              ],
            ),
            trailing: Icon(Icons.star, color: Colors.orange,),
          ),

          Container(
            margin: EdgeInsets.all(10),
            child: Text(data?.konten ?? "", style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold
            ),),
          )
        ],
      ),
    );
  }
}