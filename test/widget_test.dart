import 'package:bible/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage shows mains navigation buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('Read the Bible (Select a Version)'), findsOneWidget);
    expect(find.text('Search a keyword in the Bible'), findsOneWidget);
    expect(find.text('Daily Verse'), findsOneWidget);
  });
}
