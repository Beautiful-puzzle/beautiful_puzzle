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
    return BlocBuilder(
      blocBuilder: () {
        return GameFieldBloc();
      },
      builder: (context, bloc) {
        return const GameFieldWidget();
      },
    );
  }
}
