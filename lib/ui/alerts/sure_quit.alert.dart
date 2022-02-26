import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/models/enums.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/widgets/base/dialog.navigator.dart';
import 'package:flutter/material.dart';

class SureQuitAlert extends StatelessWidget {
  const SureQuitAlert({Key? key}) : super(key: key);

  static Future<dynamic> navigate(BuildContext context) {
    return dialogNavigate(
      context: context,
      barrierColor: Colors.black.withOpacity(.8),
      dialog: const SureQuitAlert(),
      dialogBuilder: (dialog, animation) {
        return SlideTransition(
          position: animation,
          child: dialog,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = AnimatedGestureDetector(
      onTap: () => Navigator.pop(context, DialogResponse.success),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100.0)),
          color: ColorsResource.primary,
        ),
        child: const Text(
          "Yeah",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    final nahButton = AnimatedGestureDetector(
      onTap: () => Navigator.pop(context, DialogResponse.failure),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
        child: const Text(
          "Nah",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 98),
        const Text(
          'Sure quit?',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 27),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            nahButton,
            button,
          ],
        ),
        const SizedBox(height: 66),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 330,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: ColorsResource.surface,
              borderRadius: const BorderRadius.all(const Radius.circular(20)),
            ),
            child: content,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
