import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class ScreenDataBloc extends Bloc {
  final Size designSize = const Size(1920, 961);

  final _screenSize = BehaviorSubject<Size>.seeded(Size.zero);

  ValueStream<Size> get screenSize => _screenSize;

  void updateSize(Size size) => _screenSize.add(size);

  Size getFieldSize() {
    final halfOfWidth = _calculatedFieldSize();
    return Size(halfOfWidth, halfOfWidth);
  }

  double getCardSize() {
    return getFieldSize().width / Dimens.cardsInRow.toDouble() * 0.9;
  }

  double getMarginSize() {
    return getFieldSize().width / Dimens.cardsInRow.toDouble() * 0.08;
  }

  double _calculatedFieldSize() {
    final screen = _screenSize.value;
    if (screen.width <= screen.height)
      return _screenSize.value.width / 1.1;
    else
      return _screenSize.value.width / 3;
  }

  @override
  void dispose() {
    _screenSize.close();
    super.dispose();
  }

  static ScreenDataBloc of(BuildContext context) =>
      ProviderService.of<ScreenDataBloc>(context);
}
