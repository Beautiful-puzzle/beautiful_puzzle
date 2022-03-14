import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:flutter/material.dart';

/// Base app bar for most screens of app
class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor
  const AppBarBase({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  static const double _preferredSize = 50;

  @override
  Widget build(BuildContext context) {
    final leading = AnimatedGestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: ColorsResource.primary,
        ),
        height: 50,
        width: 50,
        padding:
            const EdgeInsets.only(left: 12, right: 16, top: 10, bottom: 10),
        child: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
      ),
    );

    final titleWidget = Text(
      title ?? '',
      style: TextStyle(
        color: ColorsResource.primary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
    return SafeArea(
      child: Row(
        children: [
          leading,
          const SizedBox(width: 20),
          titleWidget,
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_preferredSize);
}
