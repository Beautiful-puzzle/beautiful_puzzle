import 'package:beautiful_puzzle/resources/animations.dart';
import 'package:beautiful_puzzle/ui/screens/menu/main_menu.screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static void navigate(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(Animations.splashIcon,
            height: 150,
            width: 150,
            repeat: true,
            reverse: true,
            controller: _controller,
            onLoaded: (_) => _controller
                .forward()
                .then((value) => MainMenuScreen.navigate(context))),
      ),
    );
  }
}
