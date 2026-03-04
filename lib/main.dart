import 'package:bible/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyBibleApp());
}

class MyBibleApp extends StatelessWidget {
  const MyBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Bible App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
