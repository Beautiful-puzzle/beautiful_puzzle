import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard_init.screen.dart';
import 'package:beautiful_puzzle/ui/screens/menu/main_menu.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/pvp_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/modes/solo_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room_await.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room_list/rooms_list.init.dart';
import 'package:beautiful_puzzle/ui/screens/splash.screen.dart';
import 'package:beautiful_puzzle/ui/widgets/base/dialog.navigator.dart';
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
    case RoomsListInit.routeName:
      return fadeInPageRoute<dynamic>(const RoomsListInit());
    case RoomAwaitScreen.routeName:
      final args = settings.arguments as RoomArgs;
      return fadeInPageRoute<dynamic>(RoomAwaitScreen(args: args));
    default:
      throw ArgumentError.value(
        settings.name,
        'settings.name',
        'Unsupported route',
      );
  }
}