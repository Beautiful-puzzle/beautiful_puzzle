import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/modes/pvp_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/solo_game.screen.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  static const String routeName = '/main_menu';

  static void navigate(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('mainMenu'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _button(
                  title: 'Single',
                  onTap: () => SoloGameScreen.navigate(context),
                ),
                const SizedBox(width: 10),
                _button(
                  title: 'PvP',
                  onTap: () => PvpGameScreen.navigate(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({
    String? title,
    VoidCallback? onTap,
  }) {
    return AnimatedGestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: ColorsResource.primary,
        ),
        child: title != null
            ? Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
