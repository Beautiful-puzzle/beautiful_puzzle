import 'package:beautiful_puzzle/initializer.dart';
import 'package:beautiful_puzzle/main.bloc.dart';
import 'package:beautiful_puzzle/repositories/leaderboard.repository.dart';
import 'package:beautiful_puzzle/ui/routes.dart';
import 'package:beautiful_puzzle/ui/screens/splash.screen.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Initializer(child: _MainBLocInitializer());
  }
}

class _MainBLocInitializer extends StatelessWidget {
  const _MainBLocInitializer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoute(settings, context),
      initialRoute: SplashScreen.routeName,
    );

    final bloc = BlocBuilder(
      blocBuilder: () {
        final bloc = MainBloc(
          leaderboardRepository: LeaderboardRepository.of(context),
        );
        return bloc;
      },
      builder: (context, bloc) {
        return materialApp;
      },
    );

    return bloc;
  }
}
