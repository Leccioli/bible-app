import 'package:flutter/material.dart';
import 'bibles_page.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.menu_book),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Read the Bible (Select a Version)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BiblesPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Search a keyword in the Bible',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.wb_sunny),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Daily Verse', style: TextStyle(fontSize: 18)),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
