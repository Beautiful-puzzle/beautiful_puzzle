import 'package:flutter/material.dart';

/// Signature for the function that builds a route's primary contents.
typedef DialogBuilder = Widget Function(
    Widget dialog, Animation<Offset> animation);

/// Provides a base dialog navigation
Future<dynamic> dialogNavigate({
  required BuildContext context,
  required Widget dialog,
  required DialogBuilder dialogBuilder,
  Color? barrierColor,
}) {
  return Navigator.of(context).push<dynamic>(
    PageRouteBuilder<dynamic>(
      opaque: false,
      barrierColor: barrierColor ?? Colors.transparent,
      pageBuilder: (context, _, __) {
        return dialog;
      },
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(curve: curve),
        );

        return dialogBuilder(child, animation.drive(tween));
      },
    ),
  );
}

/// Creates a fade in PageRouteBuilder
PageRouteBuilder<T> fadeInPageRoute<T>(
  Widget child, {
  Duration? duration,
}) {
  return PageRouteBuilder<T>(
    opaque: false,
    barrierColor: Colors.transparent,
    pageBuilder: (context, _, __) {
      return child;
    },
    transitionDuration: duration ?? const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(
        CurveTween(curve: curve),
      );

      return Opacity(
        opacity: 1 - animation.drive(tween).value.dy,
        child: child,
      );
    },
  );
}
