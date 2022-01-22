import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_events.dart';
import 'package:post_bloc_chopper/bloc/post_state.dart';
import 'package:post_bloc_chopper/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PostBloc(BlankState()),
        child: HomeScreen(),
      ),
    );
  }
}
