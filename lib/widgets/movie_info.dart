import 'package:flutter/material.dart';
import 'package:movieapp/bloc/get_movie_detail_bloc.dart';
import 'package:movieapp/bloc/get_movie_videos_bloc.dart';
import 'package:movieapp/model/movie_detail.dart';
import 'package:movieapp/style/theme.dart' as Style;
import 'package:movieapp/model/movie_detail_response.dart';

class MovieInfo extends StatefulWidget {
  final int id;
  MovieInfo({Key key, @required this.id}) : super(key: key);

  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;
  _MovieInfoState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieDetailBloc.getMovieDetail(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    movieDetailBloc.drainStream();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder: (context,AsyncSnapshot<MovieDetailResponse> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data.error!=null && snapshot.data.error.length >0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildInfoWidget(snapshot.data);
        } else if(snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        }else {
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

  Widget _buildInfoWidget(MovieDetailResponse data) {
    MovieDetail detail = data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BUDGET",style: TextStyle(
                    color: Style.Colors.titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0
                  ),),
                  SizedBox(height: 10.0,),
                  Text(
                    detail.budget.toString() + "\$",
                    style: TextStyle(
                      color: Style.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("DURATION",style: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0
                  ),),
                  SizedBox(height: 10.0,),
                  Text(
                    detail.runtime.toString() + "min",
                    style: TextStyle(
                      color: Style.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("RELEASE DATE",style: TextStyle(
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0
                  ),),
                  SizedBox(height: 10.0,),
                  Text(
                    detail.releaseDate,
                    style: TextStyle(
                      color: Style.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              "GENRES",style: TextStyle(
            color: Style.Colors.titleColor,
            fontWeight: FontWeight.w500,
            fontSize: 12.0
          ),
          ),
              Container(
                height: 38,
                padding: EdgeInsets.only(top: 5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: detail.genres.length,
                  itemBuilder: (context,index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.white,
                          )
                        ),
                        child: Text(
                          detail.genres[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 9.0
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
