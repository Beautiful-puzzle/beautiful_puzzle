import 'dart:async';

import 'package:beautiful_puzzle/main.bloc.dart';
import 'package:beautiful_puzzle/models/enums.dart';
import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:beautiful_puzzle/ui/alerts/save_game_result.alert.dart';
import 'package:beautiful_puzzle/ui/alerts/sure_quit.alert.dart';
import 'package:beautiful_puzzle/ui/game/field/game_field.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room.bloc.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:flutter/material.dart';

/// Game field initializer widget
class FieldInitializer extends StatefulWidget {
  /// Default constructor
  const FieldInitializer({Key? key, this.isAutoStart = false})
      : super(key: key);

  final bool isAutoStart;

  @override
  State<FieldInitializer> createState() => _FieldInitializerState();
}

class _FieldInitializerState extends State<FieldInitializer> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocBuilder<GameFieldBloc>(
      blocBuilder: () {
        final bloc = GameFieldBloc(isAutoStart: widget.isAutoStart);

        if (widget.isAutoStart) {
          RoomBloc.of(context).updateMovesLogs(bloc.generatedCards.value ?? []);
        }
        return bloc;
      },
      builder: (context, bloc) {
        bloc.isGameComplete.listen((isComplete) async {
          if (isComplete) {
            if (!widget.isAutoStart) {
              unawaited(
                MainBloc.of(context).addLeader(
                  username: MainBloc.of(context).username,
                  slides: bloc.getSlidesCount(),
                  time: bloc.elapsedTime.value,
                ),
              );
            }
            await Future.delayed(Dimens.delayAfterGameCompleted);
            if (!mounted) return;
            await SaveGameResultAlert.navigate(context);
          }
        });

        if (widget.isAutoStart) {
          RoomBloc.of(context).isMateGameComplete.listen((isComplete) async {
            if (isComplete) {
              await Future.delayed(Dimens.delayAfterGameCompleted);
              if (!mounted) return;
              await SaveGameResultAlert.navigate(
                context,
                name: RoomBloc.of(context).player.value!.name,
              );
            }
          });
        }

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
