import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    Key? key,
    this.child,
    this.enabled = true,
  }) : super(key: key);

  final Widget? child;
  final bool enabled;

  static const Color grayLight1 = Color(0xFFECECEC);
  static const Color grayLight3 = Color(0xFFF6F6F6);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Shimmer.fromColors(
        enabled: enabled,
        baseColor: grayLight1,
        highlightColor: grayLight3,
        child: child ?? Container(color: Colors.white),
      ),
    );
  }
}
