import 'dart:math';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:collection/collection.dart';
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
  late final Offset placeRadius = Offset(cardSize + margin, cardSize + margin);

  late Size fieldSize;
  late Size screenSize;

  final _isLoading = BehaviorSubject<bool>.seeded(false);
  final _generatedCards = BehaviorSubject<List<GameCardModel>?>.seeded(null);

  ValueStream<bool> get isLoading => _isLoading;

  ValueStream<List<GameCardModel>?> get generatedCards => _generatedCards;

  void _generateCards() {
    int random(int min, int max) {
      return min + Random().nextInt(max - min);
    }

    int newRandom(List<GameCardModel> list) {
      var generatedNumber = random(1, rowCount * colCount);

      while (list.firstWhereOrNull(
              (element) => element.number == generatedNumber) !=
          null) {
        generatedNumber = random(1, rowCount * colCount);
      }

      return generatedNumber;
    }

    final list = <GameCardModel>[];

    final emptyNumber = random(0, rowCount * colCount);
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < colCount; j++) {
        list.add(
          GameCardModel(
            id: const Uuid().v1(),
            number: list.length == emptyNumber ? -1 : newRandom(list),
            isEmpty: list.length == emptyNumber,
            offset: Offset(
              i * (cardSize + margin) + margin,
              j * (cardSize + margin) + margin,
            ),
          ),
        );
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

  Offset swapCardsPositions({
    required Offset currentPosition,
    required GameCardModel card,
  }) {
    var moveOffset = card.offset;

    if (_isNearEmptyCard(currentPosition) && _isNearEmptyCard(card.offset)) {
      moveOffset = _swapCards(card);
    }

    return moveOffset;
  }

  Offset _swapCards(GameCardModel card) {
    final list = _generatedCards.value!;

    final emptyCard = list.firstWhere((element) => element.number == -1);

    final tempOffset = emptyCard.offset;

    emptyCard.offset = card.offset;
    card.offset = tempOffset;

    list[list.indexWhere((element) => element.id == card.id)] = card;
    list[list.indexWhere((element) => element.number == -1)] = emptyCard;

    _generatedCards.add(list);

    return tempOffset;
  }

  bool _isNearEmptyCard(Offset pos1) {
    final emptyPosition =
        _generatedCards.value!.firstWhere((element) => element.number == -1);

    final dx = (emptyPosition.offset.dx - pos1.dx).abs();
    final dy = (emptyPosition.offset.dy - pos1.dy).abs();

    return (dx == 0.0 && dy <= placeRadius.dy) ||
        (dx <= placeRadius.dx && dy == 0.0);
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
