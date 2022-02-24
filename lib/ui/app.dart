import 'package:beautiful_puzzle/initializer.dart';
import 'package:beautiful_puzzle/ui/routes.dart';
import 'package:beautiful_puzzle/ui/screens/splash.screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Initializer(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) => generateRoute(settings, context),
          initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
