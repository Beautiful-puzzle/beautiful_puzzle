import 'package:flutter/material.dart';

import 'app_bar.base.dart';

/// Base widget with scaffold
class ScaffoldBase extends StatelessWidget {
  /// Default constructor
  const ScaffoldBase({
    Key? key,
    required this.body,
    this.isFirstRoute = false,
    this.extendBodyBehindAppBar = true,
    this.resizeToAvoidBottomInset,
    this.appbarTitle,
  }) : super(key: key);

  /// Child of widget
  final Widget body;

  /// If this a first route, finish nested navigator on back event
  final bool isFirstRoute;

  /// Background color of screen
  final bool extendBodyBehindAppBar;

  final bool? resizeToAvoidBottomInset;

  final String? appbarTitle;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBarBase(title: appbarTitle),
      body: body,
    );

    final offset = MediaQuery.of(context).size * .2;

    return scaffold;
  }
}
