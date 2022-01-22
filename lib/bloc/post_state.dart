import 'package:chopper/chopper.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BlankState extends PostState {}

class LoadingState extends PostState {}

class ResultState extends PostState {
  Response response;
  ResultState(this.response);

  @override
  List<Object?> get props => [response];
}

class AddState extends PostState {
  Response response;
  AddState(this.response);

  @override
  List<Object?> get props => [response];
}

class FilteredState extends PostState {
  List filteredList;
  FilteredState(this.filteredList);
}