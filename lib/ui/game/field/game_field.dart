
import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
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

    final field = RxBuilder<List<GameCardModel>?>(
      stream: GameFieldBloc.of(context).generatedCards,
      builder: (context, sList) {
        if(sList.data == null) {
          return const SizedBox();
        }

        return Stack(

          children: sList.data!
              .map((e) => GameCard(card: e))
              .toList(),
        );
      },
    );

    return Center(
      child: Container(
        color: Colors.amber,
        height: GameFieldBloc.of(context).fieldSize.height,
        width: GameFieldBloc.of(context).fieldSize.width,
        child: field,
      ),
    );
  }
}
