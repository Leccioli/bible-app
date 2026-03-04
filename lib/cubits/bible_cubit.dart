import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/bible_api_client.dart';
import 'bible_state.dart';

class BibleCubit extends Cubit<BibleState> {
  final BibleApiClient _apiClient;

  BibleCubit(this._apiClient) : super(BibleInitial());

  Future<void> loadBibles() async {
    emit(BibleLoading());

    try {
      final bibles = await _apiClient.fetchBibles();

      emit(BibleSuccess(bibles));

    } catch (e) {
      emit(BibleError('Failed to load bibles: $e'));
    }
  }
}
