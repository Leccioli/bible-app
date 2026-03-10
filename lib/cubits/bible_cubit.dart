import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/bible_repository.dart';
import 'bible_state.dart';

class BibleCubit extends Cubit<BibleState> {
  final BibleRepository _repository;

  BibleCubit(this._repository) : super(const BibleState());

  Future<void> loadBibles() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final bibles = await _repository.getBibles();
      emit(state.copyWith(loading: false, bibles: bibles));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load bibles: $e'));
    }
  }
}
