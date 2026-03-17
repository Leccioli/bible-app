import 'package:bible/cubits/reader_cubit.dart';
import 'package:bible/cubits/reader_state.dart';
import 'package:bible/data/models/bible.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chapters_page.dart';

class BooksPage extends StatelessWidget {
  final Bible bible;

  const BooksPage({super.key, required this.bible});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReaderCubit(context.read<BibleRepository>())..loadBooks(bible.id),
      child: Scaffold(
        appBar: AppBar(title: Text(bible.name)),
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
              previous.books != current.books,
          builder: (context, state) {
            if (state.loading && state.books.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.books.isEmpty) {
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
                        'No books found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try selecting a different book or check your internet connection.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return ListTile(
                  leading: const Icon(Icons.library_books),
                  title: Text(book.name),
                  subtitle: Text(book.nameLong),
                  onTap: () async {
                    await context.read<ReaderCubit>().loadChapters(book);

                    if (!context.mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ReaderCubit>(),
                          child: ChaptersPage(bookTitle: book.name),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
