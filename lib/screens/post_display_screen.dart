import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_events.dart';
import 'package:post_bloc_chopper/bloc/post_state.dart';

class PostDisplayScreen extends StatefulWidget {
  const PostDisplayScreen({Key? key}) : super(key: key);

  @override
  _PostDisplayScreenState createState() => _PostDisplayScreenState();
}

class _PostDisplayScreenState extends State<PostDisplayScreen> {


  late PostBloc _postBloc;
  List globalList = [];

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    _postBloc.add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: Container(
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state is ResultState) {
            final List posts = json.decode(state.response.bodyString);
            globalList.addAll(posts);
            return _postList(posts);
          } else if (state is FilteredState) {
            return _postList(state.filteredList);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }

  _postList(posts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              onChanged: (value) {
                _postBloc.add(FilterPost(value, globalList));
              },
              decoration: InputDecoration(hintText: "Search here..."),
            ),
          ),
          ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      posts[index]['title'],
                      style: TextStyle(color: Colors.blue),
                    ),
                    subtitle: Text(posts[index]['body']),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
