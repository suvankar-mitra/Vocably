import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ColorizeNoFadeAnimatedText extends AnimatedText {
  final List<Color> colors;
  final TextDirection textDirection;
  final Duration speed;

  late Animation<double> _colorShifter;
  late List<Color> _colors;

  ColorizeNoFadeAnimatedText(
    String text, {
    super.textAlign,
    required TextStyle super.textStyle,
    this.speed = const Duration(milliseconds: 200),
    required this.colors,
    this.textDirection = TextDirection.ltr,
  }) : assert(textStyle.fontSize != null),
       assert(colors.length > 1),
       super(text: text, duration: speed * text.characters.length);

  @override
  void initAnimation(AnimationController controller) {
    final tuning = (300.0 * colors.length) * (textStyle!.fontSize! / 24.0) * 0.75 * (textCharacters.length / 15.0);

    final colorShift = colors.length * tuning;
    final colorTween =
        textDirection == TextDirection.ltr
            ? Tween<double>(begin: 0.0, end: colorShift)
            : Tween<double>(begin: colorShift, end: 0.0);

    _colorShifter = colorTween.animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.0, 1.0, curve: Curves.easeIn)),
    );

    _colors = textDirection == TextDirection.ltr ? colors : colors.reversed.toList(growable: false);
  }

  @override
  Widget completeText(BuildContext context) {
    final linearGradient = LinearGradient(
      colors: _colors,
    ).createShader(Rect.fromLTWH(0.0, 0.0, _colorShifter.value, 0.0));

    return DefaultTextStyle.merge(
      style: textStyle,
      child: Text(text, style: TextStyle(foreground: Paint()..shader = linearGradient), textAlign: textAlign),
    );
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    // No fade in/out, just color animation
    return completeText(context);
  }
}
