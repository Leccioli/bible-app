import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/daily_verse_cubit.dart';
import '../cubits/daily_verse_state.dart';
import '../data/bible_api_client.dart';

class DailyVersePage extends StatelessWidget {
  const DailyVersePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyVerseCubit(BibleApiClient())..fetchDailyVerse(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verse of the Day'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<DailyVerseCubit, DailyVerseState>(
              builder: (context, state) {
                if (state is DailyVerseLoading || state is DailyVerseInitial) {
                  return const CircularProgressIndicator();
                } else if (state is DailyVerseError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is DailyVerseSuccess) {
                  final verse = state.verseData;
                  final cleanText =
                      verse['content']?.replaceAll(
                        RegExp(r'<[^>]*>|[\n]'),
                        '',
                      ) ??
                      '';
                  final reference = verse['reference'] ?? '';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateTime.now().toLocal().toString().split(' ')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.format_quote,
                        size: 60,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        cleanText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        reference,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'King James (Authorized) Version',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
