import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/repositories/leaderboard/leaderboard.repository.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:flutter/material.dart';

class TypeSelectorWidget extends StatefulWidget {
  const TypeSelectorWidget({Key? key, required this.onTap}) : super(key: key);

  final Function(SortBy) onTap;

  @override
  _TypeSelectorWidgetState createState() => _TypeSelectorWidgetState();
}

class _TypeSelectorWidgetState extends State<TypeSelectorWidget> {
  SortBy selectedId = SortBy.time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsResource.shade,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                      left: selectedId == SortBy.time ? constraints.maxWidth * .02 : constraints.maxWidth * .48,
                      top: 4,
                      bottom: 4,
                      duration: Dimens.fastDuration,
                      curve: Curves.fastOutSlowIn,
                      child: Container(
                        width: constraints.maxWidth / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _button(id: SortBy.time, text: 'time'),
              _button(id: SortBy.slides, text: 'slides'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _button({required SortBy id, required String text}) {
    return AnimatedGestureDetector(
      onTap: () {
        widget.onTap(id);

        selectedId = id;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 18,
        ),
        child: Text(text, textAlign: TextAlign.center,),
      ),
    );
  }
}
