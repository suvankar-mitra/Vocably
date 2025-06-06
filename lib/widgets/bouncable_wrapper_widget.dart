import 'package:flutter/material.dart';

class BouncableWrapperWidget extends StatefulWidget {
  const BouncableWrapperWidget({
    super.key,
    this.child,
    this.duration = 900,
    this.bounceBegin = 0.0,
    this.bounceEnd = 10.0,
    this.leftToRight = true,
  });

  final Widget? child;
  final int duration;
  final double bounceBegin;
  final double bounceEnd;
  final bool leftToRight;

  @override
  State<BouncableWrapperWidget> createState() => _BouncableWrapperWidgetState();
}

class _BouncableWrapperWidgetState extends State<BouncableWrapperWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration))
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.bounceBegin,
      end: widget.bounceEnd,
    ).chain(CurveTween(curve: Curves.bounceIn)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, innerChild) {
        if (widget.leftToRight) {
          return Transform.translate(offset: Offset(_animation.value, 0), child: innerChild);
        } else {
          return Transform.translate(offset: Offset(0, _animation.value), child: innerChild);
        }
      },
      child: widget.child,
    );
  }
}
