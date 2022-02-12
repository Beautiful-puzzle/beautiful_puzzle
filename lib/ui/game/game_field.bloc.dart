import 'dart:async';
import 'dart:math';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GameFieldBloc extends Bloc {
  GameFieldBloc() {
    fieldSize = Size(_colCount * (_margin + cardSize) + _margin,
        _rowCount * (_margin + cardSize) + _margin);
    _generatedCards.add(_generateCards());
    _startTimer();
  }

  final int _rowCount = 5;
  final int _colCount = 5;
  final double _margin = 20;
  late final Offset _placeRadius =
      Offset(cardSize + _margin, cardSize + _margin);
  late Timer timer;

  late Size fieldSize;
  late Size screenSize;
  final cardSize = 100.0;

  final _elapsedTime = BehaviorSubject<int>.seeded(0);
  final _generatedCards = BehaviorSubject<List<GameCardModel>?>.seeded(null);
  final _movesLogs =
      BehaviorSubject<List<Map<GameCardModel, GameCardModel>>>.seeded([]);

  ValueStream<List<GameCardModel>?> get generatedCards => _generatedCards;
  ValueStream<List<Map<GameCardModel, GameCardModel>>> get movesLogs =>
      _movesLogs;
  ValueStream<int> get elapsedTime => _elapsedTime;

  List<GameCardModel> _generateCards() {
    int random(int min, int max) {
      return min + Random().nextInt(max - min);
    }

    int newRandom(List<GameCardModel> list) {
      var generatedNumber = random(1, _rowCount * _colCount);

      while (
          list.firstWhereOrNull((element) => element.id == generatedNumber) !=
              null) {
        generatedNumber = random(1, _rowCount * _colCount);
      }

      return generatedNumber;
    }

    final list = <GameCardModel>[];

    final emptyNumber = random(0, _rowCount * _colCount);
    for (var i = 0; i < _rowCount; i++) {
      for (var j = 0; j < _colCount; j++) {
        list.add(
          GameCardModel(
            id: list.length == emptyNumber ? -1 : newRandom(list),
            isEmpty: list.length == emptyNumber,
            offset: Offset(
              j * (cardSize + _margin) + _margin,
              i * (cardSize + _margin) + _margin,
            ),
          ),
        );
      }
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
            element.offset = newCards
                .firstWhere((generatedCard) => generatedCard.id == element.id)
                .offset;
          },
        ),
    );

    _startTimer();
  }

  void isGameCompleted() {
    final list = <GameCardModel>[]..addAll(_generatedCards.value!);

    for (var i = 0; i < list.length - 1; i++) {
      for (var j = 0; j < list.length - i - 1; j++) {
        var additionalOffset = .0;
        final item = list[j];
        final nextItem = list[j + 1];

        if (item.offset.dy < nextItem.offset.dy && nextItem.offset.dx < item.offset.dx) {
          additionalOffset = _colCount * (_margin + cardSize);
        }

        //print('${item.id} : ${nextItem.id}  +$additionalOffset ');

        if (item.offset.dx > (nextItem.offset.dx + additionalOffset)) {
          final tempItem = nextItem;

          list[j + 1] = item;
          list[j] = tempItem;
        }
      }
    }

    print('');
    print(list.map((e) => e.id).join(', '));
    print('');
   // print(exampleList.join(', '));
    print('');


  }

  Offset swapCardsPositions({
    required Offset currentPosition,
    required GameCardModel card,
  }) {
    var moveOffset = card.offset;

    if (_isNearEmptyCard(currentPosition, isBothAxis: true) && _isNearEmptyCard(card.offset)) {
      moveOffset = _swapCards(card);
    }

    //isGameCompleted();

    return moveOffset;
  }

  Offset _swapCards(GameCardModel card) {
    final list = _generatedCards.value!;

    final emptyCard = list.firstWhere((element) => element.id == -1);

    final tempOffset = emptyCard.offset;

    emptyCard.offset = card.offset;
    card.offset = tempOffset;

    list[list.indexWhere((element) => element.id == card.id)] = card;
    list[list.indexWhere((element) => element.id == -1)] = emptyCard;

    _generatedCards.add(list);
    _movesLogs.add(_movesLogs.value..add({card: emptyCard}));
    return tempOffset;
  }

  bool _isNearEmptyCard(Offset pos1, {bool isBothAxis = false}) {
    final emptyPosition =
        _generatedCards.value!.firstWhere((element) => element.id == -1);

    final dx = (emptyPosition.offset.dx - pos1.dx).abs();
    final dy = (emptyPosition.offset.dy - pos1.dy).abs();

    if(isBothAxis) {
      return dx <= _placeRadius.dx && dy <= _placeRadius.dy;
    }

    return (dx == 0.0 && dy <= _placeRadius.dy) ||
        (dx <= _placeRadius.dx && dy == 0.0);
  }

  void _clearLogs() {
    _movesLogs.add([]);
  }

  @override
  void dispose() {
    _generatedCards.close();
    _movesLogs.close();
    _elapsedTime.close();
    super.dispose();
  }

  static GameFieldBloc of(BuildContext context) =>
      ProviderService.of<GameFieldBloc>(context);
}
