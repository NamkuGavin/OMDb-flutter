import 'package:flutter/material.dart';
import 'package:omdbmovie_app/db/db_provider.dart';
import 'package:omdbmovie_app/model/favorite_model.dart';

import 'detail_page.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({Key? key}) : super(key: key);

  @override
  State<FavoritPage> createState() => _FavoritPageState();

}

class _FavoritPageState extends State<FavoritPage> {
  var memos;
  bool isLoading = false;
  DbProvider favDb = DbProvider();

  @override
  initState() {
    // TODO: implement initState
    super.initState();

    getAlldata();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading == false ? Center(child: CircularProgressIndicator()) :Container(
      child: ListView.builder(
          itemCount: memos.length,
          itemBuilder: (context, index) {
            final movie = memos[index];

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
                          deletedata(movie.id);
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
    );
  }

  void getAlldata() async{
    memos = await favDb.fetchMovies();
    setState(() {
      isLoading = true;
    });
  }
  void deletedata(int id) async{
    memos = await favDb.deleteMovies(id);
    Future.delayed(Duration(milliseconds: 500));
    memos = await favDb.fetchMovies();
    setState(() {
      isLoading = true;
    });
  }

}
