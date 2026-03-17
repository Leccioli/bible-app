import 'package:bible/cubits/reader_cubit.dart';
import 'package:bible/cubits/reader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ReaderCubit, ReaderState>(
          buildWhen: (previous, current) =>
              previous.currentChapter != current.currentChapter,
          builder: (context, state) {
            return Text(state.currentChapter?.reference ?? 'Reader');
          },
        ),
      ),
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
            previous.currentChapter != current.currentChapter,
        builder: (context, state) {
          if (state.loading && state.currentChapter == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final chapter = state.currentChapter;
          final isNavigating = state.loading && chapter != null;
          if (chapter == null) {
            return const Center(child: Text('No chapter loaded'));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Html(
                    data: chapter.content,
                    style: {
                      'body': Style(
                        fontSize: FontSize(18),
                        lineHeight: const LineHeight(1.6),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      'p': Style(margin: Margins.only(bottom: 14)),
                      '.v': Style(
                        fontSize: FontSize.smaller,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                        padding: HtmlPaddings.only(right: 6),
                      ),
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    if (isNavigating) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                chapter.previousChapterId == null ||
                                    isNavigating
                                ? null
                                : () => context
                                      .read<ReaderCubit>()
                                      .loadPreviousChapter(),
                            child: Text(
                              isNavigating ? 'Loading...' : 'Previous',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                chapter.nextChapterId == null || isNavigating
                                ? null
                                : () => context
                                      .read<ReaderCubit>()
                                      .loadNextChapter(),
                            child: Text(isNavigating ? 'Loading...' : 'Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
