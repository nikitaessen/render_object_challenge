import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CircularRenderObject extends MultiChildRenderObjectWidget {
  const CircularRenderObject({
    super.key,
    required super.children,
    required this.radius,
    required this.startAngle,
  });

  final double radius;
  final double startAngle;

  @override
  void updateRenderObject(
      BuildContext context, covariant CircularRenderBox renderObject) {
    renderObject.customRadius = radius;
    renderObject.customAngle = startAngle;
    super.updateRenderObject(context, renderObject);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CircularRenderBox(
      customRadius: radius,
      startAngle: startAngle,
    );
  }
}

class CircularRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, CircularParentData> {
  CircularRenderBox({
    required double customRadius,
    required double startAngle,
  })  : _customRadius = customRadius,
        _startAngle = startAngle;

  double _customRadius;
  double _startAngle;

  double get customRadius => _customRadius;
  set customRadius(double value) {
    if (_customRadius != value) {
      _customRadius = value;
      markNeedsLayout();
    }
  }

  double get customAngle => _startAngle;
  set customAngle(double value) {
    if (_startAngle != value) {
      _startAngle = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CircularParentData) {
      child.parentData = CircularParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size = constraints.constrain(
      Size(constraints.maxWidth, constraints.maxHeight),
    );
    return size;
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    final customAngleInRadians = customAngle * pi / 180;
    final angleStep = 2 * pi / childCount;

    final computedSize = Size(_customRadius * 2, _customRadius * 2);
    size = constraints.constrain(computedSize);

    var child = firstChild;
    var index = 0;
    while (child != null) {
      child.layout(constraints.loosen(), parentUsesSize: true);

      final angle = index * angleStep + customAngleInRadians;
      final x =
          size.width / 2 + cos(angle) * _customRadius - child.size.width / 2;
      final y =
          size.height / 2 + sin(angle) * _customRadius - child.size.height / 2;

      (child.parentData as CircularParentData).offset = Offset(x, y);
      child = childAfter(child);
      index++;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final CircularParentData childParentData =
          child.parentData as CircularParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childAfter(child);
    }
  }
}

class CircularParentData extends ContainerBoxParentData<RenderBox> {}
