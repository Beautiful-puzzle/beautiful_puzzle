import 'dart:async';

import 'package:beautiful_puzzle/main.bloc.dart';
import 'package:beautiful_puzzle/models/enums.dart';
import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:beautiful_puzzle/ui/alerts/save_game_result.alert.dart';
import 'package:beautiful_puzzle/ui/alerts/sure_quit.alert.dart';
import 'package:beautiful_puzzle/ui/game/field/game_field.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:flutter/material.dart';

/// Game field initializer widget
class FieldInitializer extends StatefulWidget {
  /// Default constructor
  const FieldInitializer({Key? key}) : super(key: key);

  @override
  State<FieldInitializer> createState() => _FieldInitializerState();
}

class _FieldInitializerState extends State<FieldInitializer> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocBuilder<GameFieldBloc>(
      blocBuilder: () {
        return GameFieldBloc();
      },
      builder: (context, bloc) {
        bloc.isGameComplete.listen((isComplete) async {
          if (isComplete) {
            unawaited(
              MainBloc.of(context).addLeader(
                username: "Test name",
                slides: bloc.getSlidesCount(),
                time: bloc.elapsedTime.value,
              ),
            );
            await Future.delayed(Dimens.delayAfterGameCompleted);
            if (!mounted) return;
            await SaveGameResultAlert.navigate(context);
          }
        });

        return const GameFieldWidget();
      },
    );

    return WillPopScope(
      child: bloc,
      onWillPop: () async {
        final result = await SureQuitAlert.navigate(context);

        if (result == DialogResponse.success && mounted) {
          Navigator.pop(context);
        }

        return Future.value(false);
      },
    );
  }
}
