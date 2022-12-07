class MovieModel {
  MovieModel({
    required this.imageUrl,
    required this.title,
    required this.genres,
    required this.duration,
    required this.rating,
  });

  String title;
  String genres;
  String imageUrl;
  int duration;
  double rating;
}
