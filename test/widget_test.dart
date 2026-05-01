// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_app/app.dart';
import 'package:states_app/features/counter/counter_injection.dart';

void main() {
  testWidgets('App widget smoke test', (WidgetTester tester) async {
    // Set up shared preferences for testing
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize counter BLoC
    final counterBloc = await CounterInjection.initCounter(sharedPreferences);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(counterBloc: counterBloc),
    );

    // Verify that the app initializes properly
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Close the BLoC
    await counterBloc.close();
  });
}
