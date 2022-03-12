import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Finish callback.
typedef OnFinishCallback = void Function(Object? result);

/// A wrapper over [Navigator] that:
/// - automatically handles nested back navigation
/// - provides a [NestedNavigatorController] to each child page that allows for
///   managing a parent [Navigator] stack in a decoupled manner.
///
/// Use it whenever some set of pages has to be reused with different
/// entry/exit-points.
class NestedNavigator extends StatefulWidget {
  /// Constructs an instance of [NestedNavigator].
  const NestedNavigator({
    Key? key,
    this.initialRoute,
    required this.onGenerateRoute,
    this.onUnknownRoute,
    this.observers = const <NavigatorObserver>[],
    this.onFinish,
  }) : super(key: key);

  /// The route generator callback used when the app is navigated to a named
  /// route.
  ///
  /// If this returns null when building the routes to handle the specified
  /// [initialRoute], then all the routes are discarded and
  /// [Navigator.defaultRouteName] is used instead (/). See [initialRoute].
  ///
  /// During normal app operation, the [onGenerateRoute] callback will only
  /// be applied to route names pushed by the application, and so should
  /// never return null.
  ///
  /// The [Navigator] is only built if routes are provided (either via
  /// [onGenerateRoute], or [onUnknownRoute]).
  final RouteFactory onGenerateRoute;

  /// The name of the first route to show, if a [Navigator] is built.
  final String? initialRoute;

  ///Called when [onGenerateRoute] fails to generate a route, except for
  ///the [initialRoute].
  ///
  /// This callback is typically used for error handling. For example,
  /// this callback might always generate a "not found" page that
  /// describes the route that wasn't found.
  ///
  /// Unknown routes can arise either from errors in the app or from
  /// external requests to push routes, such as from Android intents.
  ///
  /// The [Navigator] is only built if routes are provided (either
  /// via [onGenerateRoute], or [onUnknownRoute]).
  final RouteFactory? onUnknownRoute;

  /// The list of observers for the [Navigator] created for this app.
  ///
  /// This list must be replaced by a list of newly-created observers
  /// if the [WidgetsApp.navigatorKey] is changed.
  ///
  /// The [Navigator] is only built if routes are provided (either via
  /// [onGenerateRoute], or [onUnknownRoute]).
  final List<NavigatorObserver> observers;

  /// An optional callback that is triggered whenever
  /// `NestedNavigator.of(context).finish()` is called.
  ///
  /// If specified, no default
  /// no maybePop will not be called automatically upon NestedNavigator.finish()
  final OnFinishCallback? onFinish;

  @override
  _NestedNavigatorState createState() => _NestedNavigatorState();

  /// The data from the closest [NestedNavigatorController] instance that
  /// encloses the given context.
  static NestedNavigatorController of(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_NestedNavigatorInheritedWidget>();
    if (widget == null) {
      throw StateError(
          'NestedNavigator widget must exist in the widget tree above');
    }

    return NestedNavigatorController._(
      widget,
      widget._isManualPop,
      widget._childNestedNavigator,
      widget.parentNavigator,
      widget.parentNavigatorRoute,
      widget.onFinish,
    );
  }

  static NestedNavigatorController? maybeOf(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_NestedNavigatorInheritedWidget>();
    if (widget == null) {
      return null;
    }

    return NestedNavigatorController._(
      widget,
      widget._isManualPop,
      widget._childNestedNavigator,
      widget.parentNavigator,
      widget.parentNavigatorRoute,
      widget.onFinish,
    );
  }
}

class _NestedNavigatorState extends State<NestedNavigator> {
  final _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final result = _NestedNavigatorInheritedWidget(
      parentNavigator: Navigator.of(context),
      parentNavigatorRoute: ModalRoute.of(context),
      nestedNavigatorKey: _navKey,
      onFinish: widget.onFinish,
      child: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () {
            return _popNestedNavigator(NestedNavigator.of(context));
          },
          child: Navigator(
            key: _navKey,
            initialRoute: widget.initialRoute,
            observers: [HeroController(), ...widget.observers],
            onGenerateRoute: widget.onGenerateRoute,
            onUnknownRoute: widget.onUnknownRoute,
          ),
        ),
      ),
    );

    final parentNestedNavigator = context
        .getElementForInheritedWidgetOfExactType<
            _NestedNavigatorInheritedWidget>()
        ?.widget as _NestedNavigatorInheritedWidget?;
    parentNestedNavigator?._childNestedNavigator.value = result;

    return result;
  }
}

Future<bool> _popNestedNavigator(
    NestedNavigatorController? nestedNavigator) async {
  if (nestedNavigator == null) {
    return true;
  }

  final nestedNavigators = nestedNavigator._nestedNavigators;
  var deepestNestedNavigatorIndex =
      nestedNavigators.lastIndexWhere((_) => true);
  while (deepestNestedNavigatorIndex >= 0 &&
      nestedNavigators[deepestNestedNavigatorIndex]
              ?.nestedNavigatorKey
              ?.currentState ==
          null) {
    deepestNestedNavigatorIndex--;
  }

  final navigator =
      nestedNavigator._nestedNavigator.nestedNavigatorKey.currentState;

  if (deepestNestedNavigatorIndex >= 0) {
    final deepestNestedNavigator =
        nestedNavigators[deepestNestedNavigatorIndex];
    final deepestNavigator =
        deepestNestedNavigator?.nestedNavigatorKey.currentState;

    final isManualPop = nestedNavigator._isManualPop.value == true ||
        deepestNestedNavigator?._isManualPop?.value == true;
    if (!isManualPop) {
      final popResult = await deepestNavigator?.maybePop();
      return popResult == false;
    }
  } else if (navigator != null) {
    final isManualPop = nestedNavigator._isManualPop.value;
    if (isManualPop == false) {
      final popResult = await navigator.maybePop();
      return !popResult;
    }
  }
  return true;
}

/// Controller that allows to `finish` or `pop` nested navigators graph
/// from the parent [Navigator].
class NestedNavigatorController {
  NestedNavigatorController._(
    this._nestedNavigator,
    this._isManualPop,
    this._childNestedNavigator,
    this._parentNavigator,
    this._parentNavigatorRoute,
    this._onFinish,
  );

  final _NestedNavigatorInheritedWidget _nestedNavigator;
  final ValueNotifier<bool?> _isManualPop;
  final ValueNotifier<_NestedNavigatorInheritedWidget?> _childNestedNavigator;
  final NavigatorState _parentNavigator;
  final ModalRoute? _parentNavigatorRoute;
  final OnFinishCallback? _onFinish;

  List<_NestedNavigatorInheritedWidget?> get _nestedNavigators {
    final result = <_NestedNavigatorInheritedWidget?>[];
    var nestedNavigator = _childNestedNavigator.value;
    while (nestedNavigator?._childNestedNavigator?.value != null) {
      nestedNavigator = nestedNavigator?._childNestedNavigator.value;
      result.add(nestedNavigator);
    }
    return result;
  }

  /// Gets parent route.
  ModalRoute? get parentNavigatorRoute => _parentNavigatorRoute;

  /// Pops the nested navigation graph from the parent [Navigator] if possible.
  Future<bool> maybePop<T extends Object>([T? result]) async {
    _isManualPop.value = true;
    final ret = await _parentNavigator.maybePop<dynamic>(result);
    _isManualPop.value = false;
    return ret;
  }

  /// Pops the nested navigation graph from the parent [Navigator].
  void pop<T extends Object>([T? result]) {
    _isManualPop.value = true;
    _parentNavigator.pop<dynamic>(result);
    _isManualPop.value = false;
  }

  /// Pops the nested navigation graph from the parent [Navigator] or
  /// triggers `onFinish` callback of [NestedNavigator] if it is provided.
  void finish<T extends Object>([T? result]) {
    if (_onFinish != null) {
      _onFinish!(result);
    } else {
      pop(result);
    }
  }

  @override
  String toString() => '${_nestedNavigator.toStringShort()}'
      '(${identityHashCode(_nestedNavigator)})';
}

class _NestedNavigatorInheritedWidget extends InheritedWidget {
  _NestedNavigatorInheritedWidget({
    Key? key,
    required this.parentNavigator,
    required this.parentNavigatorRoute,
    required this.nestedNavigatorKey,
    required this.onFinish,
    required Widget child,
  }) : super(key: key, child: child);

  final NavigatorState parentNavigator;
  final ModalRoute? parentNavigatorRoute;
  final GlobalKey<NavigatorState> nestedNavigatorKey;
  final OnFinishCallback? onFinish;

  final _isManualPop = ValueNotifier<bool?>(false);
  final _childNestedNavigator =
      ValueNotifier<_NestedNavigatorInheritedWidget?>(null);

  @override
  bool updateShouldNotify(_NestedNavigatorInheritedWidget old) => false;
}
