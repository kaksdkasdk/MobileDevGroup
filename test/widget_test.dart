// Basic test: checks that the app starts and shows the home screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_calander/main.dart';

void main() {
  testWidgets('App starts on the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('My planner'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
