import 'package:flutter/material.dart';
import 'dart:math';

/// An interpolation between two [AlignmentGeometry].
///
/// This class specializes the interpolation of [Tween<AlignmentGeometry>]
/// to be appropriate for alignments.
///
/// See [Tween] for a discussion on how to use interpolation objects.
///
/// See also:
///
///  * [AlignmentTween], which interpolates between two [Alignment] objects.
class AlignmentGeometryNTween extends Tween<AlignmentGeometry> {
  /// Creates a fractional offset geometry tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as meaning the center.
  AlignmentGeometryNTween({
    required AlignmentGeometry begin,
    required AlignmentGeometry end,
  }) : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  AlignmentGeometry lerp(double t) => AlignmentGeometry.lerp(begin, end, t)!;
}

class ColorNTween extends Tween<Color> {
  /// Creates a [Color] tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as transparent.
  ///
  /// We recommend that you do not pass [Colors.transparent] as [begin]
  /// or [end] if you want the effect of fading in or out of transparent.
  /// Instead prefer null. [Colors.transparent] refers to black transparent and
  /// thus will fade out of or into black which is likely unwanted.
  ColorNTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}

class DelayTween extends Tween<double> {
  DelayTween({
    required double begin,
    required double end,
    required this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
