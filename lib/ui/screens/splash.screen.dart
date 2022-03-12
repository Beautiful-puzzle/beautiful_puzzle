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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then(
      (value) => MainMenuScreen.navigate(context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          Animations.splashIcon,
          height: 500,
          width: 500,
        ),
      ),
    );
  }
}
