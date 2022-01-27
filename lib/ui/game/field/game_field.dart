import 'dart:math' as math;

import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/ui/game/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:flutter/material.dart';


class GameFieldWidget extends StatefulWidget {
  const GameFieldWidget({Key? key}) : super(key: key);

  @override
  State<GameFieldWidget> createState() => _GameFieldWidgetState();
}

class _GameFieldWidgetState extends State<GameFieldWidget> {
  @override
  Widget build(BuildContext context) {
    GameFieldBloc.of(context).screenSize = MediaQuery.of(context).size;

    return Center(
      child: Container(
        color: Colors.amber,
        height: GameFieldBloc.of(context).fieldSize.height,
        width: GameFieldBloc.of(context).fieldSize.width,
        child: Stack(
          children: GameFieldBloc.of(context).generatedCards,
        ),
      ),
    );
  }


}
