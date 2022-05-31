import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omdbmovie_app/model/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:omdbmovie_app/page/detail_page.dart';

class SearchPage extends StatefulWidget {
  String searchValue = "";
  SearchPage({Key? key, required this.searchValue}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final scrollController = ScrollController();
  List<MovieModel> _movies = <MovieModel>[];
  bool isFav = false;
  int? _selectedIndex;
  List<MovieModel> favoriteDataList = <MovieModel>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSearchedMovies(widget.searchValue);
  }

  Future<List<MovieModel>> _fetchSearchedMovies(String searchValue) async {
    String url =
        "http://www.omdbapi.com/?s=$searchValue&page=1&apikey=6e79f3b4";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["Search"];

      setState(() {
        _movies
            .addAll(list.map((movie) => MovieModel.fromJson(movie)).toList());
      });
      return _movies;
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  void _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search result for: " + widget.searchValue),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: _movies.length + 1,
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
                                          : Image.network(movie.poster),
                                      borderRadius: BorderRadius.circular(10),
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
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteDataList.add(_movies[index]);
                                });
                                _onSelected(index);
                              },
                              icon: Icon(
                                _selectedIndex != null &&
                                        _selectedIndex == index
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
