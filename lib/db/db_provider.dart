import 'package:omdbmovie_app/model/favorite_model.dart';
import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import ''; //import model class
import 'dart:io';
import 'dart:async';

import '../model/movie_model.dart';

class DbProvider{

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"memos.db"); //create path to database

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE Movies(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idimdb TEXT,
          title TEXT,
          year TEXT,
          poster TEXT)"""
          );
        });
  }

  Future<int> addItem(FavModel item) async{ //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert("Movies", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<FavModel>> fetchMovies() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Movies"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return FavModel(
        id: int.parse(maps[i]['id'].toString()),
        idimdb: maps[i]['idimdb'].toString(),
        title: maps[i]['title'].toString(),
        poster: maps[i]['poster'].toString(),
        year: maps[i]['year'].toString(),
      );
    });
  }

  Future<int> deleteMovies(int id) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "Movies", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
    );

    return result;
  }

}