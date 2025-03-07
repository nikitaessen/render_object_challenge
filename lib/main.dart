import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:render_object_challenge/circular_render_object.dart';

const double kAnimationSpeedFactor = 0.2;

class CircularLayout extends StatefulWidget {
  const CircularLayout({super.key});

  @override
  State<CircularLayout> createState() => _CircularLayoutState();
}

class _CircularLayoutState extends State<CircularLayout>
    with SingleTickerProviderStateMixin {
  double radius = 100;
  double startAngle = 0;
  double itemAngle = 0;
  late Ticker _ticker;
  late List<Color> _itemColors;

  @override
  void initState() {
    _ticker = createTicker((elapsed) {
      setState(() {
        itemAngle =
            (elapsed.inMilliseconds / 1000.0) * 2 * pi * kAnimationSpeedFactor;
      });
    })
      ..start();

    _itemColors = List.generate(
        6, (index) => Colors.primaries[index % Colors.primaries.length]);

    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Circle Radius'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    radius = (radius - 40).clamp(40, 180);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    radius = (radius + 40).clamp(40, 180);
                  });
                },
              ),
            ],
          ),
        ),
        const Text('Starting Angle'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    startAngle = (startAngle - 10) % 360;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    startAngle = (startAngle + 10) % 360;
                  });
                },
              ),
            ],
          ),
        ),
        CircularRenderObject(
          radius: radius,
          startAngle: startAngle,
          children: _itemColors
              .map(
                (color) => Transform.rotate(
                  angle: itemAngle,
                  child: Container(
                    width: 40,
                    height: 40,
                    color: color,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(child: CircularLayout()),
    ),
  ));
}
