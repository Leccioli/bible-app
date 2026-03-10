import 'package:equatable/equatable.dart';
import '../data/models/bible.dart';

class BibleState extends Equatable {
  final bool loading;
  final String? error;
  final List<Bible> bibles;

  const BibleState({this.loading = false, this.error, this.bibles = const []});

  BibleState copyWith({bool? loading, String? error, List<Bible>? bibles}) {
    return BibleState(
      loading: loading ?? this.loading,
      error: error,
      bibles: bibles ?? this.bibles,
    );
  }

  @override
  List<Object?> get props => [loading, error, bibles];
}
