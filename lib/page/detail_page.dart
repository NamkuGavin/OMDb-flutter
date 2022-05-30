import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omdbmovie_app/model/detail_model.dart';
import 'package:omdbmovie_app/model/movie_model.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String model;
  DetailPage({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  detailModel? movieDetail;

  @override
  void initState() {
    // TODO: implement initState
    fetchDetail();
    super.initState();
  }

  fetchDetail() async {
    String url =
        "https://www.omdbapi.com/?i=" + widget.model + "&apikey=6e79f3b4";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      setState(() {
        movieDetail = detailModel.fromJson(json.decode(res.body.toString()));
      });
      return movieDetail;
    } else {
      throw Exception("Failed to load detail!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
                width: 100,
                child: ClipRRect(
                  child: movieDetail!.poster == "N/A"
                      ? Text("No Picture")
                      : Image.network(movieDetail!.poster),
                  borderRadius: BorderRadius.circular(10),
                )),
            Text(movieDetail!.title),
            Text(movieDetail!.plot),
          ],
        ),
      ),
    );
  }
}
