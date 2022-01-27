import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GameFieldBloc extends Bloc {
  GameFieldBloc(Widget Function(Offset) card) {
    fieldSize = Size(colCount * (margin + cardSize) + margin,
        rowCount * (margin + cardSize) + margin);
    generatedCards = _generateCards(card);
  }

  final int rowCount = 5;
  final int colCount = 5;
  final double margin = 10;
  final cardSize = 60.0;

  late Size fieldSize;
  late List<Widget> generatedCards;
  late Size screenSize;

  final _isLoading = BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get isLoading => _isLoading;

  List<Widget> _generateCards(Widget Function(Offset) card) {
    final list = <Widget>[];

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < colCount; j++) {
        list.add(
          card(
            Offset(
              i * (cardSize + margin) + margin,
              j * (cardSize + margin) + margin,
            ),
          ),
        );
      }
    }

    return list;
  }

  @override
  void dispose() {
    _isLoading.close();
    super.dispose();
  }

  static GameFieldBloc of(BuildContext context) =>
      ProviderService.of<GameFieldBloc>(context);
}
