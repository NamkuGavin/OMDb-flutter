class detailModel {
  final String imdbId;
  final String title;
  final String poster;
  final String plot;

  detailModel({
    required this.imdbId,
    required this.plot,
    required this.poster,
    required this.title,
  });

  factory detailModel.fromJson(Map<String, dynamic> json) {
    return detailModel(
        imdbId: json["imdbID"],
        plot: json["Plot"],
        poster: json["Poster"],
        title: json["Title"]);
  }
}
