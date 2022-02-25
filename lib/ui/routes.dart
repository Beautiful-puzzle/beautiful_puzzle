import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard_init.screen.dart';
import 'package:beautiful_puzzle/ui/screens/main_menu.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/pvp_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/solo_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/splash.screen.dart';
import 'package:beautiful_puzzle/ui/widget/base/dialog.navigator.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
  switch (settings.name) {
    case '/':
      return fadeInPageRoute<dynamic>(const SplashScreen());
    case MainMenuScreen.routeName:
      return fadeInPageRoute<dynamic>(const MainMenuScreen());
    case SoloGameScreen.routeName:
      return fadeInPageRoute<dynamic>(const SoloGameScreen());
    case PvpGameScreen.routeName:
      return fadeInPageRoute<dynamic>(const PvpGameScreen());
    case LeaderBoardInit.routeName:
      return fadeInPageRoute<dynamic>(const LeaderBoardInit());
    default:
      throw ArgumentError.value(
        settings.name,
        'settings.name',
        'Unsupported route',
      );
  }
}