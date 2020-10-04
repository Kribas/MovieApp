import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/bloc/get_movies_byGenre_bloc.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/style/theme.dart' as Style;
import 'package:movieapp/model/movie_response.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;

  GenreMovies({Key key, @required this.genreId})
    :super(key: key);

  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies> {
  final int genreId;

  _GenreMoviesState(this.genreId);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesByGenreBloc.getMoviesByGenre(genreId);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context,AsyncSnapshot<MovieResponse> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildMoviesByGenreWidget(snapshot.data);
        }

        else if(snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);}

        else {
          return _buildLoadingWidget();
        }
      },

    );

  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ),

          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error"),
        ],
      ),
    );
  }

  Widget _buildMoviesByGenreWidget(MovieResponse data) {
    List<Movie> movies = data.movies;

    if(movies.length == 0) {
      return Container(
        child: Text('No Movies'),
      );
    } else {
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context,index) {
            return Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 10.0
              ),
              child: Column(
                children: [
                  movies[index].poster == null ?
                      Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                         color:  Style.Colors.secondColor,
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          shape: BoxShape.rectangle
                        ),
                        child: Column(
                          children: [
                            Icon(EvaIcons.filmOutline,color: Colors.white,size: 50.0,),
                            
                          ],
                        ),
                      ) :
                      Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage("https://image.tmdb.org/t/p/w200/" + movies[index].poster),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: 100,
                    child: Text(
                      movies[index].title
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    }


  }
}
