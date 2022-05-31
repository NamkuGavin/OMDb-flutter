class FavModel {
  final int id;
  final String idimdb;
  final String poster;
  final String title;
  final String year;

  FavModel(
      {required this.id,
      required this.idimdb,
      this.poster = "",
      this.title = "",
      this.year = ""});

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "idimdb": idimdb,
      "title": title,
      "poster": poster,
      "year": year,
    };
  }
}
