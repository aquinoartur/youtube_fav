import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_fav/blocs/favorite_bloc.dart';
import 'package:youtube_fav/models/video.dart';


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Favoritos",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, Video>>(
        initialData: {},
        stream: bloc.outFav,
        builder: (context, snapshot) {
          return ListView(
            padding: EdgeInsets.only(top: 10),
            children: snapshot.data.values.map((video) {
              return InkWell(
                onLongPress: (){
                  bloc.toggleFavorite(video);
                },
                child: Column(
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
                              color: Colors.black,),
                          maxLines: 2,
                        ))
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
