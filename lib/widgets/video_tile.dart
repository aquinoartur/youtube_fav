import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_fav/blocs/favorite_bloc.dart';
import 'package:youtube_fav/models/video.dart';

class VideoTile extends StatelessWidget {
  final Video video;
  const VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        video.title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(video.channel,
                          style:
                              TextStyle(fontSize: 13, color: Colors.black87)),
                    )
                  ],
                )),
                StreamBuilder<Map<String, Video>>(
                    stream: bloc.outFav,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                            icon: Icon(snapshot.data.containsKey(video.id)
                                ? Icons.star
                                : Icons.star_border),
                            onPressed: () {
                              bloc.toggleFavorite(video);
                            });
                      } else {
                        return Container();
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
