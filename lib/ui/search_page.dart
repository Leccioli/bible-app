import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/bible_cubit.dart';
import '../cubits/bible_state.dart';
import '../cubits/search_cubit.dart';
import '../cubits/search_state.dart';
import '../data/bible_api_client.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _selectedBibleId;
  final TextEditingController _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(BibleApiClient()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search for a Keyword')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocBuilder<BibleCubit, BibleState>(
                  builder: (context, state) {
                    if (state is BibleSuccess) {
                      return DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width - 32,
                        hintText: 'Type or select a Bible version',
                        enableSearch: true,
                        onSelected: (value) => _selectedBibleId = value,
                        dropdownMenuEntries: state.bibles.map((bible) {
                          return DropdownMenuEntry<String>(
                            value: bible.id,
                            label: bible.name,
                          );
                        }).toList(),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryController,
                        decoration: const InputDecoration(
                          labelText: 'Enter keyword to search',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.search, size: 32),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            if (_selectedBibleId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a Bible version',
                                  ),
                                ),
                              );
                              return;
                            }
                            final query = _queryController.text.trim();
                            if (query.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter a keyword to search',
                                  ),
                                ),
                              );
                              return;
                            }
                            context.read<SearchCubit>().search(
                              _selectedBibleId!,
                              query,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SearchError) {
                        return Center(child: Text(state.message));
                      } else if (state is SearchSuccess) {
                        final verses = state.verses;
                        if (verses.isEmpty) {
                          return const Center(
                            child: Text('No verses found for this keyword.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: verses.length,
                          itemBuilder: (context, index) {
                            final verse = verses[index];
                            return ListTile(
                              title: Text(verse['reference'] ?? ''),
                              subtitle: Text(
                                verse['text']?.replaceAll('\n', '') ?? '',
                              ),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: Text(
                          'Enter a keyword and select a Bible to search.',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
