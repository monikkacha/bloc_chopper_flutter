import 'package:equatable/equatable.dart';

abstract class PostEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmptyPosts extends PostEvents {}

class FetchPosts extends PostEvents {}

class AddPost extends PostEvents {
  String postData;

  AddPost(this.postData);

  @override
  List<Object?> get props => [postData];
}

class FilterPost extends PostEvents {
  List posts;
  String term;

  FilterPost(this.term, this.posts);

  @override
  List<Object?> get props => [term, posts];
}