import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/screen.data.dart';
import 'package:flutter/material.dart';

class ScreenSize extends StatelessWidget {
  const ScreenSize({Key? key, required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenDataBloc>(
      blocBuilder: () {
        return ScreenDataBloc();
      },
      builder: (context, bloc) {
        return LayoutBuilder(
          builder: (context, constraints) {
            bloc.updateSize(Size(constraints.maxWidth, constraints.maxHeight));

            return child;
          },
        );
      },
    );

  }
}
