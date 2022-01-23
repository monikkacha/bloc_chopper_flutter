import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_events.dart';
import 'package:post_bloc_chopper/bloc/post_state.dart';
import 'package:post_bloc_chopper/widgets/shared_bottom_sheet.dart';

class PostDisplayScreen extends StatefulWidget {
  const PostDisplayScreen({Key? key}) : super(key: key);

  @override
  _PostDisplayScreenState createState() => _PostDisplayScreenState();
}

class _PostDisplayScreenState extends State<PostDisplayScreen> {
  late PostBloc _postBloc;
  List globalList = [];
  List filteredList = [];
  bool isListView = true;

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    _postBloc.add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isListView = !isListView;
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(isListView ? Icons.dashboard : Icons.list),
      ),
      body: Container(
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state is ResultState) {
            final List posts = json.decode(state.response.bodyString);
            globalList.addAll(posts);
            filteredList.addAll(posts);
            return _showResult(filteredList);
          } else if (state is FilteredState) {
            return _showResult(filteredList);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }

  _showResult(posts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              onChanged: (value) {
                // _postBloc.add(FilterPost(value, globalList));
                _filter(value);
              },
              decoration: InputDecoration(hintText: "Search here..."),
            ),
          ),
          isListView ? _postList(posts) : _gridList(posts)
        ],
      ),
    );
  }

  _gridList(posts) {
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () => ShareBottomSheet.get(context, posts[index]),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    posts[index]['id'].toString(),
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    posts[index]['title'],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _postList(posts) {
    return ListView.builder(
        itemCount: posts.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () => ShareBottomSheet.get(context, posts[index]),
              title: Text(
                posts[index]['id'].toString(),
                style: TextStyle(color: Colors.blue),
              ),
              subtitle: Text(posts[index]['title']),
            ),
          );
        });
  }

  _filter(term) {
    if (term.toString().isEmpty) {
      print("got into if");
      filteredList.clear();
      filteredList.addAll(globalList);
    } else {
      var filter = [];
      filter = globalList
          .where((i) => i["title"].toString().contains(term.toString()))
          .toList();
      filteredList.clear();
      filteredList.addAll(filter);
    }
    setState(() {});
  }
}
