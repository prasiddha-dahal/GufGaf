import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(value, 0.0),
            _dot(value, 0.2),
            _dot(value, 0.4),
          ],
        );
      },
    );
  }

  Widget _dot(double value, double delay) {
    final animationValue = ((value - delay) % 1.0);

    final opacity = 0.3 +
        (animationValue < 0.5
            ? animationValue * 2
            : (1 - animationValue) * 2) *
            0.7;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}