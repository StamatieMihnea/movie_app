import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    @JsonKey(name: 'large_cover_image') required String imageUrl,
    @JsonKey(name: 'runtime') required int duration,
    required String title,
    required List<String> genres,
    required num rating,
  }) = Movie$;

  factory Movie.fromJson(Map<dynamic, dynamic> json) => _$MovieFromJson(Map<String, dynamic>.from(json));
}
