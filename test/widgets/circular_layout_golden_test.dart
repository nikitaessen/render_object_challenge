import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:render_object_challenge/main.dart';

void main() {
  group('Contact List Tile Golden Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'circular_layout',
      builder: () => TickerMode(
        enabled: false,
        child: GoldenTestGroup(
          children: [
            GoldenTestScenario(
              name: 'Circular layout',
              constraints: const BoxConstraints(
                minWidth: 400,
                maxWidth: 600,
              ),
              child: const CircularLayout(),
            ),
          ],
        ),
      ),
    );
  });
}
