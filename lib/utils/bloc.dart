import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';

/// Widget builder that provides BLoC.
typedef BlocWidgetBuilder<T extends Bloc> = Widget Function(
    BuildContext context,
    T bloc,
    );

/// BLoC interface.
abstract class Bloc {
  /// Defines a constant ctor for [Bloc] descendants.
  const Bloc();

  /// Disposes resources.
  void dispose() {}
}

/// Simplifies operating with BLoC within page.
@immutable
class BlocBuilder<T extends Bloc> extends StatefulWidget {
  /// Constructs an instance of [BlocBuilder].
  const BlocBuilder({
    Key? key,
    required this.blocBuilder,
    required this.builder,
    this.autodispose = true,
  })  : bloc = null,
        super(key: key);

  /// Constructs an instance of [BlocBuilder] with given BLoC.
  const BlocBuilder.value({
    Key? key,
    required this.bloc,
    required this.builder,
    this.autodispose = true,
  })  : blocBuilder = null,
        super(key: key);

  /// BLoC.
  final T? bloc;

  /// Function that builds BLoC.
  final T Function()? blocBuilder;

  /// Widget builder that provides BLoC.
  final BlocWidgetBuilder<T> builder;

  /// Whether ro auto dispose bloc or not.
  final bool autodispose;

  @override
  _BlocBuilderState<T> createState() => _BlocBuilderState<T>();
}

class _BlocBuilderState<T extends Bloc> extends State<BlocBuilder<T>> {
  late T _bloc;

  @override
  void initState() {
    _bloc = widget.bloc ?? widget.blocBuilder!();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderService(
      data: <Type, dynamic>{
        T: _bloc,
        ...ProviderService.parentProviders(context),
      },
      builder: (context) {
        return widget.builder(context, _bloc);
      },
    );
  }

  @override
  void dispose() {
    if (widget.autodispose) {
      _bloc.dispose();
    }
    super.dispose();
  }
}