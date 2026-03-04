import 'package:bible/cubits/bible_cubit.dart';
import 'package:bible/data/bible_api_client.dart';
import 'package:bible/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyBibleApp());
}

class MyBibleApp extends StatelessWidget {
  const MyBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BibleCubit(BibleApiClient())..loadBibles(),
      child: MaterialApp(
        title: 'My Bible App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
