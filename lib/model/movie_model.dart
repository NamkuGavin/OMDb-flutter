class movieModel {
  final String imdbId;
  final String poster;
  final String title;
  final String year;

  movieModel(
      {required this.imdbId,
      required this.title,
      required this.poster,
      required this.year});

  factory movieModel.fromJson(Map<String, dynamic> json) {
    return movieModel(
        imdbId: json["imdbID"],
        poster: json["Poster"],
        title: json["Title"],
        year: json["Year"]);
  }
}
