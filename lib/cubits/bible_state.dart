import '../data/models/bible.dart';

abstract class BibleState {}

class BibleInitial extends BibleState {}

class BibleLoading extends BibleState {}

class BibleSuccess extends BibleState {
  final List<Bible> bibles;

  BibleSuccess(this.bibles);
}

class BibleError extends BibleState {
  final String message;

  BibleError(this.message);
}