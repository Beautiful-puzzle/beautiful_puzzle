import 'dart:async';
import 'dart:math';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GameFieldBloc extends Bloc {
  GameFieldBloc() {
    _generatedCards.add(_generateCards());
    _startTimer();
  }

  Offset emptyCardOffset = Offset.zero;

  late Timer timer;

  final _elapsedTime = BehaviorSubject<int>.seeded(0);
  final _generatedCards = BehaviorSubject<List<GameCardModel>?>.seeded(null);
  final _movesLogs =
      BehaviorSubject<List<Map<GameCardModel, GameCardModel>>>.seeded([]);
  final _isGameComplete = BehaviorSubject<bool>.seeded(false);

  ValueStream<List<GameCardModel>?> get generatedCards => _generatedCards;
  ValueStream<List<Map<GameCardModel, GameCardModel>>> get movesLogs =>
      _movesLogs;
  ValueStream<int> get elapsedTime => _elapsedTime;
  ValueStream<bool> get isGameComplete => _isGameComplete;

  List<GameCardModel> _generateCards() {
    int random(int min, int max) {
      return min + Random().nextInt(max - min);
    }

    int newRandom(List<GameCardModel> list) {
      var generatedNumber = random(1, Dimens.cardsInRow * Dimens.cardsInRow);

      while (list.firstWhereOrNull(
            (element) => element.id == generatedNumber,
          ) !=
          null) {
        generatedNumber = random(1, Dimens.cardsInRow * Dimens.cardsInRow);
      }

      return generatedNumber;
    }

    final list = <GameCardModel>[];

    final emptyNumber = random(0, Dimens.cardsInRow * Dimens.cardsInRow);
    for (var i = 0; i < Dimens.cardsInRow * Dimens.cardsInRow; i++) {
      final position = newRandom(list);
      list.add(
        GameCardModel(
          id: list.length == emptyNumber ? -1 : position,
          isEmpty: list.length == emptyNumber,
          position: /*i*/ list.length == emptyNumber ? 24 : position - 1,
        ),
      );
    }

    return list;
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime.add(++_elapsedTime.value);
    });
  }

  void _clearCountdown() {
    _elapsedTime.add(0);
    timer.cancel();
  }

  void shuffle() {
    _clearLogs();
    _clearCountdown();

    final newCards = _generateCards();
    _generatedCards.add(
      _generatedCards.value!
        ..forEach(
          (element) {
            element.position = newCards
                .firstWhere((generatedCard) => generatedCard.id == element.id)
                .position;
          },
        ),
    );

    _startTimer();
  }

  void isGameCompleted() {
    var isCompleted = false;
    for (final element in _generatedCards.value!) {
      if (element.id == -1) continue;

      isCompleted = element.id == element.position + 1;

      if (element.id != element.position + 1) break;
    }

    if (isCompleted != _isGameComplete.value) {
      _isGameComplete.add(isCompleted);
    }
  }

  int getSlidesCount() => movesLogs.value.length;

  int swapCardsPositions({
    required Offset currentOffset,
    required Offset offsetRadius,
    required GameCardModel card,
  }) {
    var movePosition = card.position;

    final emptyCard =
        _generatedCards.value!.firstWhere((element) => element.id == -1);

    if ((emptyCard.position - card.position).abs() == 1 ||
        emptyCard.position - 5 == card.position ||
        emptyCard.position + 5 == card.position) {
      if (_isNearEmptyCard(currentOffset, offsetRadius, isBothAxis: true)) {
        movePosition = _swapCards(card);
      }
    }

    isGameCompleted();

    return movePosition;
  }

  int _swapCards(GameCardModel card) {
    final list = _generatedCards.value!;

    final emptyCard = list.firstWhere((element) => element.id == -1);

    final tempPosition = emptyCard.position;

    emptyCard.position = card.position;
    card.position = tempPosition;

    list[list.indexWhere((element) => element.id == card.id)] = card;
    list[list.indexWhere((element) => element.id == -1)] = emptyCard;

    _generatedCards.add(list);
    _movesLogs.add(_movesLogs.value..add({card: emptyCard}));
    return tempPosition;
  }

  bool _isNearEmptyCard(Offset pos1, Offset placeRadius,
      {bool isBothAxis = false}) {
    final dx = (emptyCardOffset.dx - pos1.dx).abs();
    final dy = (emptyCardOffset.dy - pos1.dy).abs();

    if (isBothAxis) {
      return dx <= placeRadius.dx && dy <= placeRadius.dy;
    }

    return (dx == 0.0 && dy <= placeRadius.dy) ||
        (dx <= placeRadius.dx && dy == 0.0);
  }

  void _clearLogs() {
    _movesLogs.add([]);
  }

  @override
  void dispose() {
    _clearCountdown();

    _generatedCards.close();
    _movesLogs.close();
    _elapsedTime.close();
    _isGameComplete.close();
    super.dispose();
  }

  static GameFieldBloc of(BuildContext context) =>
      ProviderService.of<GameFieldBloc>(context);
}
