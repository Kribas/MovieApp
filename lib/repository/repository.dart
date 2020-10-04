import 'package:dio/dio.dart';
import 'package:movieapp/model/movie_response.dart';
import 'package:movieapp/model/genre_response.dart';
import 'package:movieapp/model/person_response.dart';

class MovieRepository {
  final String apiKey = "62dc2010b852ea4ae6fb12b199a5c94b";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();
  var getPopularUrl = '$mainUrl/movie/top_rated';
  var getMovieUrl = '$mainUrl/discover/movie';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var getGenresUrl = '$mainUrl/movie/list';
  var getPersonsUrl = '$mainUrl/movie/person/week';

  Future<MovieResponse> getMovies() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1
    };
    
    try {
      Response response = await _dio.get(getPopularUrl,queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }catch(error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return MovieResponse.withError("$error");
    }
  }
  
  Future<MovieResponse> getPlayingMovies() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1
    };
    
    try {
      Response response = await _dio.get(getPlayingUrl,queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }catch(error,stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return MovieResponse.withError('$error');

    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1
    };

    try {
      Response response = await _dio.get(getGenresUrl,queryParameters: params);
      return GenreResponse.fromJson(response.data);
    }catch(error,stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return GenreResponse.withError('$error');

    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {
      "api_key": apiKey,
    };

    try {
      Response response = await _dio.get(getPersonsUrl,queryParameters: params);
      return PersonResponse.fromJson(response.data);
    }catch(error,stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return PersonResponse.withError('$error');

    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
      "with_genres": id
    };

    try {
      Response response = await _dio.get(getMovieUrl,queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }catch(error,stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return MovieResponse.withError('$error');

    }
  }

}