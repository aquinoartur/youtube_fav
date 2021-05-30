import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_fav/blocs/favorite_bloc.dart';

import 'api.dart';
import 'blocs/videos_bloc.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocs: [
          Bloc((i)=>VideosBloc()),
          Bloc((ii)=>FavoriteBloc()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.black,
            ),
            textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black87, fontSize: 18)
            )
          ),
          home: HomePage(),
        ) );
  }
}
