import 'dart:math';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class GameFieldBloc extends Bloc {
  GameFieldBloc() {
    fieldSize = Size(colCount * (margin + cardSize) + margin,
        rowCount * (margin + cardSize) + margin);
    _generateCards();
  }

  final int rowCount = 5;
  final int colCount = 5;
  final double margin = 20;
  final cardSize = 100.0;

  late Size fieldSize;
  late Size screenSize;

  final _isLoading = BehaviorSubject<bool>.seeded(false);
  final _generatedCards = BehaviorSubject<List<GameCardModel>?>.seeded(null);

  ValueStream<bool> get isLoading => _isLoading;

  ValueStream<List<GameCardModel>?> get generatedCards => _generatedCards;

  void _generateCards() {
    int random(int min, int max){
      return min + Random().nextInt(max - min);
    }

    final list = <GameCardModel>[];

    var currentNumber = 1;

    final emptyNumber = random(0, rowCount * colCount);
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < colCount; j++) {
        list.add(
          GameCardModel(
            id: const Uuid().v1(),
            number: currentNumber,
            isEmpty: list.length == emptyNumber,
            offset: Offset(
              i * (cardSize + margin) + margin,
              j * (cardSize + margin) + margin,
            ),
          ),
        );
        if(list.length != emptyNumber) currentNumber++;
      }
    }

    _generatedCards.add(list);
  }

  void topOrder(String id) {
    /*final item =
        _generatedCards.value!.firstWhere((element) => element.id == id);

    _generatedCards.add(
      _generatedCards.value!
        ..removeWhere((element) => element.id == id)
        ..add(item),
    );*/
  }

  @override
  void dispose() {
    _isLoading.close();
    _generatedCards.close();
    super.dispose();
  }

  static GameFieldBloc of(BuildContext context) =>
      ProviderService.of<GameFieldBloc>(context);
}
