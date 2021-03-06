part of 'number_trivia_bloc.dart';

@module
abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  Loaded({required this.trivia}) : super();
}

class Error extends NumberTriviaState {
  final String message;
  Error({required this.message}) : super();
}
