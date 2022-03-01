
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends Bloc {

  final _elapsedTime = BehaviorSubject<int>.seeded(0);

  ValueStream<int> get elapsedTime => _elapsedTime;

  @override
  void dispose() {
    _elapsedTime.close();
    super.dispose();
  }

  static MainBloc of(BuildContext context) =>
      ProviderService.of<MainBloc>(context);
}
