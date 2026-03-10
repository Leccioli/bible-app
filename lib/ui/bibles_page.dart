import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/bible_cubit.dart';
import '../cubits/bible_state.dart';

class BiblesPage extends StatelessWidget {
  const BiblesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Bible'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<BibleCubit, BibleState>(
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
            previous.bibles != current.bibles,
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.bibles.isEmpty) {
            return const Center(child: Text('No bibles found'));
          }

          return ListView.builder(
            itemCount: state.bibles.length,
            itemBuilder: (context, index) {
              final bible = state.bibles[index];
              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(bible.name),
                subtitle: Text(bible.abbreviation),
                onTap: () {
                  debugPrint(
                    'You\'ve selected ${bible.name} (${bible.abbreviation})',
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
