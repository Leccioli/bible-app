import 'package:bible/cubits/bible_cubit.dart';
import 'package:bible/data/bible_api_client.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:bible/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final apiClient = BibleApiClient();
  final repository = BibleRepository(apiClient);

  runApp(MyBibleApp(repository: repository));
}

class MyBibleApp extends StatelessWidget {
  final BibleRepository repository;

  const MyBibleApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => repository,
      child: BlocProvider(
        create: (context) => BibleCubit(
          context.read<BibleRepository>(),
        )..loadBibles(),
        child: MaterialApp(
          title: 'My Bible App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
