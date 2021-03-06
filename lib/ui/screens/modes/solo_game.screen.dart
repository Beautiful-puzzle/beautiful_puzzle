import 'package:beautiful_puzzle/ui/game/field/field.initializer.dart';
import 'package:beautiful_puzzle/ui/widgets/base/scaffold.base.dart';
import 'package:beautiful_puzzle/ui/widgets/screen_size.widget.dart';
import 'package:flutter/material.dart';

class SoloGameScreen extends StatelessWidget {
  const SoloGameScreen({Key? key}) : super(key: key);

  static const String routeName = '/solo_game';

  static void navigate(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const ScaffoldBase(
      extendBodyBehindAppBar: false,
      body: ScreenSize(
        child: FieldInitializer(),
      ),
    );
  }
}
