import 'package:flutter/material.dart';

class AnimatedSwapWidget extends StatelessWidget {
  const AnimatedSwapWidget({
    Key? key,
    required this.child,
    required this.child1,
    required this.isFirstVisible,
    this.alignment = Alignment.center,
    this.shouldFill = false,
    this.shouldIgnore = true,
  }) : super(key: key);

  final Widget child;
  final Widget child1;

  final Alignment alignment;

  final bool isFirstVisible;

  final bool shouldFill;
  final bool shouldIgnore;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        if(shouldFill) Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isFirstVisible ? 1 : 0,
            child: isFirstVisible ? child : null,
          ),
        ) else AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isFirstVisible ? 1 : 0,
          child: isFirstVisible ? child : null,
        ),
        IgnorePointer(
          ignoring: shouldIgnore,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isFirstVisible ? 0 : 1,
            child: child1,
          ),
        ),
      ],
    );
  }
}
