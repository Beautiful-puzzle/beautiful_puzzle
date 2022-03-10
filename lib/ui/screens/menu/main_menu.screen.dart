import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard_init.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/pvp_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/solo_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room_list/rooms_list.init.dart';
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
        child: Row(
          children: [
            const Spacer(),
            Column(
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
                      onTap: () => RoomsListInit.navigate(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _button(
                  title: 'Leaderboard',
                  onTap: () => LeaderBoardInit.navigate(context),
                  isSquare: false,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _button({
    String? title,
    VoidCallback? onTap,
    bool isSquare = true,
    EdgeInsets? padding,
  }) {
    return AnimatedGestureDetector(
      onTap: onTap,
      child: Container(
        height: isSquare ? 100 : null,
        width: isSquare ? 100 : 100 * 2 + 10,
        padding: padding,
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
