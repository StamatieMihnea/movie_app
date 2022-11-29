import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/models/movie_model.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MovieAppHomePage(),
    );
  }
}

class MovieAppHomePage extends StatefulWidget {
  const MovieAppHomePage({super.key});

  @override
  State<MovieAppHomePage> createState() => _MovieAppHomePageState();
}

class _MovieAppHomePageState extends State<MovieAppHomePage> {
  final PageController pageController = PageController(
    viewportFraction: 0.7,
  );
  final List<MovieModel> _movies = <MovieModel>[];
  bool _isLoading = true;
  double _currentPageValue = 0;

  void _getMovies() {
    _isLoading = true;
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      final Map<String, dynamic> fullData = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = fullData['data'] as Map<String, dynamic>;
      final List<dynamic> moviesData = data['movies'] as List<dynamic>;
      setState(() {
        _movies.addAll(
          moviesData.map((dynamic movie) {
            final Map<String, dynamic> movieData = movie as Map<String, dynamic>;
            final List<String> genres = <String>[
              ...(movieData['genres'] as List<dynamic>).map((dynamic element) => element as String)
            ];
            final String genresString = genres.first;
            _isLoading = false;
            return MovieModel(
              title: movieData['title'] as String,
              genres: genresString,
              duration: movieData['runtime'] as int,
              rating: double.parse(movieData['rating'].toString()),
              imageUrl: movieData['large_cover_image'] as String,
            );
          }),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getMovies();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page != null ? pageController.page! : 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topCenter,
          colors: <Color>[Colors.indigoAccent, Colors.lightBlueAccent],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Movies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {},
            ),
          ),
        ),
        body: Builder(
          builder: (BuildContext context) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else {
              return PageView.builder(
                controller: pageController,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Transform(
                        transform: Matrix4.rotationX((_currentPageValue - index) * .5),
                        child: PhysicalModel(
                          elevation: 30,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_movies[index % _movies.length].imageUrl),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Transform(
                        transform: Matrix4.identity()..scale(1 - (index - _currentPageValue).abs()),
                        child: Column(
                          children: <Widget>[
                            Text(
                              _movies[index % _movies.length].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _movies[index % _movies.length].genres,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${_movies[index % _movies.length].duration} min',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${_movies[index % _movies.length].rating}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Rating',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                                  child: Text(
                                    'Buy tickets',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
