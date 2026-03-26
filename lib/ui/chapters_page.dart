import 'package:bible/cubits/reader/reader_cubit.dart';
import 'package:bible/cubits/reader/reader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reader_page.dart';

class ChaptersPage extends StatelessWidget {
  final String bookTitle;

  const ChaptersPage({super.key, required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookTitle)),
      body: BlocConsumer<ReaderCubit, ReaderState>(
        listenWhen: (previous, current) => previous.error != current.error,
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
            previous.chapters != current.chapters,
        builder: (context, state) {
          if (state.loading && state.chapters.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.chapters.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No chapters found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try selecting a different chapter or check your internet connection.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.chapters.length,
            itemBuilder: (context, index) {
              final chapter = state.chapters[index];
              return ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: Text('Chapter ${chapter.number}'),
                subtitle: Text(chapter.reference),
                onTap: () async {
                  await context.read<ReaderCubit>().loadChapter(chapter.id);

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ReaderCubit>(),
                        child: const ReaderPage(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
