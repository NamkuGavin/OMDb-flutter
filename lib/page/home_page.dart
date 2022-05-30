import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omdbmovie_app/model/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:omdbmovie_app/page/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<movieModel> _movies = <movieModel>[];

  @override
  void initState() {
    super.initState();
    _fetchAllMovies();
  }

  Future<List<movieModel>> _fetchAllMovies() async {
    final response = await http
        .get(Uri.parse("http://www.omdbapi.com/?s=Top Gun&apikey=6e79f3b4"));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      setState(() {
        _movies = list.map((movie) => movieModel.fromJson(movie)).toList();
      });
      return _movies;
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Movies App",
        home: Scaffold(
            appBar: AppBar(title: Text("Movies")),
            body: Column(
              children: [
                Container(
                  height: 550,
                  child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailPage(model: movie.imdbId,)));
                            ;
                          },
                          child: ListTile(
                              title: Row(
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: ClipRRect(
                                    child: movie.poster == "N/A"
                                        ? Text("No Picture")
                                        : Image.network(movie.poster),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(movie.title),
                                      Text(movie.year)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                        );
                      }),
                )
              ],
            )));
  }
}
