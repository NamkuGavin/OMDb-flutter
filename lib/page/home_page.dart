import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omdbmovie_app/db/db_provider.dart';
import 'package:omdbmovie_app/model/favorite_model.dart';
import 'package:omdbmovie_app/model/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:omdbmovie_app/page/detail_page.dart';
import 'package:omdbmovie_app/page/favorit_page.dart';
import 'package:omdbmovie_app/page/info_page.dart';
import 'package:omdbmovie_app/page/movies_page.dart';
import 'package:omdbmovie_app/page/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Movies"),
              backgroundColor: Colors.deepPurple,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.article_rounded)),
                  Tab(icon: Icon(Icons.favorite)),
                  Tab(
                    icon: Icon(Icons.info),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MoviesPage(),
                FavoritPage(),
                InfoPage()
              ],
            )));
  }
}
