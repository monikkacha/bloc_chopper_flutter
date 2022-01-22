import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_bloc_chopper/bloc/post_events.dart';
import 'package:post_bloc_chopper/bloc/post_state.dart';
import 'package:post_bloc_chopper/network/post_api_service.dart';

class PostBloc extends Bloc<PostEvents, PostState> {
  PostBloc(PostState initialState) : super(initialState);

  @override
  Stream<PostState> mapEventToState(PostEvents event) async* {
    if (event is FetchPosts) {
      yield* _fetchPosts();
    } else if (event is AddPost) {
      yield* _addPost(event);
    } else if (event is EmptyPosts) {
      yield BlankState();
    } else if (event is FilterPost) {
      yield* _filter(event);
    }
  }

  Stream<PostState> _fetchPosts() async* {
    yield LoadingState();
    var response = await PostApiService.create().getPosts();
    yield ResultState(response);
  }

  Stream<PostState> _addPost(event) async* {
    yield LoadingState();
    var response = await PostApiService.create().postPost({"": event.postData});
    print("results : ${response.bodyString}");
    yield AddState(response);
  }

  Stream<PostState> _filter(event) async* {
    if (event.term.toString().isEmpty) {
      yield FilteredState(event.posts);
    } else {
      var filter = [];
      filter = event.posts
          .where((i) => i["title"].toString().contains(event.term.toString()))
          .toList();
      yield FilteredState(filter);
    }
  }
}
