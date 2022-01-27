import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Applies all objects provided in [data] to descendant widgets.
///
/// Descendant widgets obtain the current object
/// using [ProviderService.of].
@immutable
class ProviderService extends StatefulWidget {
  /// Constructs an instance of [ProviderService].
  const ProviderService({
    Key? key,
    required this.data,
    required this.builder,
  }) : super(key: key);

  /// Called to obtain the child widget.
  ///
  /// This function is called whenever this widget is included in its parent's
  /// build and the old widget (if any) that it synchronizes with has a distinct
  /// object identity. Typically the parent's build method will construct
  /// a new tree of widgets and so a new Builder child will not be [identical]
  /// to the corresponding old one.
  final WidgetBuilder builder;

  /// Map of all objects, where:
  ///
  ///   - **key** is a [Type] of object;
  ///   - **value** is a object itself.
  final Map<Type, dynamic> data;

  @override
  ProviderServiceState createState() => ProviderServiceState();

  /// Gets object by [context] and object [Type].
  ///
  /// The data from the closest [ProviderService] instance that encloses
  /// the given context.
  static T of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_InheritedServiceProvider>();
    return provider!.data[T] as T;
  }

  /// Gets objects by [context].
  ///
  /// The data from the all closests [ProviderService] instances that encloses
  /// the given context.
  static Map<Type, dynamic> parentProviders(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_InheritedServiceProvider>();
    return provider!.data;
  }
}

/// State of [ProviderService].
class ProviderServiceState extends State<ProviderService> {
  @override
  Widget build(BuildContext context) {
    return _InheritedServiceProvider(
      data: widget.data,
      child: Builder(
        builder: widget.builder,
      ),
    );
  }
}

class _InheritedServiceProvider extends InheritedWidget {
  const _InheritedServiceProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final Map<Type, dynamic> data;

  @override
  bool updateShouldNotify(_InheritedServiceProvider old) => old.data != data;
}
