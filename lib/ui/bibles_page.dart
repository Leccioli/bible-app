import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/bible_cubit.dart';
import '../cubits/bible_state.dart';

class BiblesPage extends StatefulWidget {
  const BiblesPage({super.key});

  @override
  State<BiblesPage> createState() => _BiblesPageState();
}

class _BiblesPageState extends State<BiblesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BibleCubit>().loadBibles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Bible'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<BibleCubit, BibleState>(
        builder: (context, state) {
          if (state is BibleInitial || state is BibleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BibleError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is BibleSuccess) {
            final bibles = state.bibles;
            return ListView.builder(
              itemCount: bibles.length,
              itemBuilder: (context, index) {
                final bible = bibles[index];
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(bible.name),
                  subtitle: Text(bible.abbreviation),
                  onTap: () {
                    print(
                      'You\'ve selected ${bible.name} (${bible.abbreviation})',
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
