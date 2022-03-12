import 'package:beautiful_puzzle/ui/screens/modes/pvp_game.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room_await.screen.dart';
import 'package:beautiful_puzzle/ui/widgets/base/dialog.navigator.dart';
import 'package:beautiful_puzzle/utils/nested_navigator.dart';
import 'package:flutter/material.dart';

class RoomRouter extends StatelessWidget {
  const RoomRouter({Key? key, required this.args}) : super(key: key);

  final RoomArgs args;
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoomAwaitScreen.routeName:
        return fadeInPageRoute<dynamic>(RoomAwaitScreen(args: args));

      case PvpGameScreen.routeName:
        return fadeInPageRoute<dynamic>(const PvpGameScreen());

      default:
        throw ArgumentError.value(
          settings.name,
          'settings.name',
          'Unsupported route',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedNavigator(
      onGenerateRoute: (settings) {
        var newSettings = settings;
        if (settings.name == '/') {
          newSettings = settings.copyWith();
        }
        return _generateRoute(newSettings);
      },
    );
  }
}
