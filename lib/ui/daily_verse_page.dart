import 'package:bible/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/daily_verse/daily_verse_cubit.dart';
import '../cubits/daily_verse/daily_verse_state.dart';
import '../data/repositories/bible_repository.dart';

class DailyVersePage extends StatelessWidget {
  const DailyVersePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DailyVerseCubit(context.read<BibleRepository>())..fetchDailyVerse(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verse of the Day'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<DailyVerseCubit, DailyVerseState>(
              listenWhen: (previous, current) =>
                  previous.error != current.error,
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.loading != current.loading ||
                  previous.dailyVerse != current.dailyVerse,
              builder: (context, state) {
                if (state.loading) {
                  return const CircularProgressIndicator();
                }

                final dailyVerse = state.dailyVerse;
                if (dailyVerse == null) {
                  return const Text('No verse available');
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateTime.now().toLocal().toString().split(' ')[0],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Icon(
                      Icons.format_quote,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dailyVerse.cleanContent,
                      style: const TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      dailyVerse.verse.reference,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppConstants.defaultBibleName,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
