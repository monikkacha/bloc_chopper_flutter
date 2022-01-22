import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_events.dart';
import 'package:post_bloc_chopper/bloc/post_state.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController textEditingController = TextEditingController();
  late PostBloc _postBloc;

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    _postBloc.add(EmptyPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, event) {
          if (event is BlankState) {
            return _addPostWidget();
          } else if (event is AddState) {
            if (event.response.statusCode == 200 ||
                event.response.statusCode == 201) {
              return _showMsg("post added successfully");
            } else {
              return _showMsg("post failed");
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _addPostWidget() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: "Start typing here..."),
          controller: textEditingController,
        ),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton(onPressed: addPost, child: Text("Add"))
      ],
    );
  }

  _showMsg(text) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(text),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () {
                  _postBloc.add(EmptyPosts());
                },
                child: Text("Try again"))
          ],
        ),
      ),
    );
  }

  addPost() {
    var post = textEditingController.value.text;
    _postBloc.add(AddPost(post));
    textEditingController.text = "";
  }
}
