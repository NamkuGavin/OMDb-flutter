import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omdbmovie_app/page/search_page.dart';

import '../db/db_provider.dart';
import '../model/favorite_model.dart';
import '../model/movie_model.dart';
import 'package:http/http.dart' as http;

import 'detail_page.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final scrollController = ScrollController();
  List<MovieModel> _movies = <MovieModel>[];
  bool isFav = false;
  int? _selectedIndex;
  List<MovieModel> favoriteDataList = <MovieModel>[];
  int page = 1;
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = false;
  DbProvider favDB = DbProvider();

  @override
  void initState() {
    super.initState();
    _fetchAllMovies();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        _fetchAllMovies();
      }
    });
  }

  Future<List<MovieModel>> _fetchAllMovies() async {
    String url = "http://www.omdbapi.com/?s=Batman&page=$page&apikey=6e79f3b4";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["Search"];

      setState(() {
        page += 1;
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
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: searchTextController,
                style: TextStyle(fontSize: 15),
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  searchValue:
                                  searchTextController.text,
                                )));
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
            Container(
              height: MediaQuery.of(context).size.height * 0.74,
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: _movies.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _movies.length) {
                      final movie = _movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailPage(
                                    model: movie.title,
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
                                      Text(movie.title, style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),),
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
                                FavModel model = FavModel(
                                    id: index,
                                    idimdb: movie.imdbId,
                                    title: movie.title,
                                    year: movie.year,
                                    poster: movie.poster);
                                favDB.addItem(model);
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
                    } else {
                      return Center(
                          child: CircularProgressIndicator());
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
