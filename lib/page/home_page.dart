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
  List<movieModel> favoriteDataList = <movieModel>[];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllMovies();
  }

  Future<List<movieModel>> _fetchAllMovies() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get(Uri.parse("http://www.omdbapi.com/?s=Batman&apikey=6e79f3b4"));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      setState(() {
        _movies = list.map((movie) => movieModel.fromJson(movie)).toList();
        isLoading = false;
      });
      return _movies;
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  Future<List<movieModel>> _fetchSearchedMovies(String searchValue) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        "http://www.omdbapi.com/?s=" + searchValue + "&apikey=6e79f3b4"));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      setState(() {
        _movies = list.map((movie) => movieModel.fromJson(movie)).toList();
        isLoading = false;
      });
      return _movies;
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Movies"),
              backgroundColor: Colors.deepPurple,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.article_rounded)),
                  Tab(icon: Icon(Icons.favorite)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(fontSize: 15),
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  String searchInput = searchController.text;
                                  print(searchInput);
                                  _fetchSearchedMovies(searchInput);
                                },
                                icon: Icon(Icons.search)),
                            contentPadding: EdgeInsets.all(12),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: 'Search for movies',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: _movies.length,
                                  itemBuilder: (context, index) {
                                    final movie = _movies[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DetailPage(
                                                      model: movie.imdbId,
                                                    )));
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
                                                    : Image.network(
                                                        movie.poster),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(movie.title),
                                                  Text(movie.year)
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                favoriteDataList
                                                    .add(_movies[index]);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.favorite,
                                              color: Colors.purple,
                                            ),
                                          )
                                        ],
                                      )),
                                    );
                                  }),
                            ),
                    ],
                  ),
                ),
                favoriteDataList.isEmpty
                    ? const Center(
                        child: Text(
                          'There are no favorites yet!',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: favoriteDataList.length,
                            itemBuilder: (context, index) {
                              final movie = favoriteDataList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DetailPage(
                                                model: movie.imdbId,
                                              )));
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                    Expanded(
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
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          favoriteDataList
                                              .remove(favoriteDataList[index]);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.purple,
                                      ),
                                    )
                                  ],
                                )),
                              );
                            }),
                      ),
              ],
            )));
  }
}
