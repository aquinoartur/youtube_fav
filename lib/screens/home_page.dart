import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_fav/blocs/favorite_bloc.dart';
import 'package:youtube_fav/blocs/videos_bloc.dart';
import 'package:youtube_fav/delegates/data_search.dart';
import 'package:youtube_fav/models/video.dart';
import 'package:youtube_fav/screens/favorites_page.dart';
import 'package:youtube_fav/widgets/video_tile.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<VideosBloc>();
    final bloc2 = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset("assets/yt.png", width: 75,),
        backgroundColor: Colors.white,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Text("${snapshot.data.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star, color: Colors.black,),
            onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoritesPage()));

            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black,),
            onPressed: () async {
              String result = await showSearch(context: context, delegate: DataSearch());
              if (result!=null && result != ""){
                bloc.inSearch.add(result);
              }
            },
          )
        ],
      ),
      body: StreamBuilder<List<Video>>(
        stream: bloc.outVideos,
        initialData: [],
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 16, right: 10,),
                    alignment: Alignment.centerLeft,
                    child: Text("Meus favoritos", style: GoogleFonts.poppins(fontSize: 20),),
                  ),
                  StreamBuilder<Map<String, Video>>(
                    initialData: {},
                    stream: bloc2.outFav,
                    builder: (context, snapshot) {
                      return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, left: 0, right: 10),
                        children: snapshot.data.values.map((video) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 50,
                                    child: Image.network(video.thumb),
                                  ),
                                  Expanded(
                                    child: Text(
                                      video.title,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,)
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            default:
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, index){
                      if(index < snapshot.data.length){
                        return VideoTile(snapshot.data[index]);
                      } else if (index > 1){
                        bloc.inSearch.add(null);

                        return Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black),),
                        );
                      } else {
                        return Container();
                      }
                    }
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black),),
                );
              }
          }
        },

      ),
    );
  }
}
