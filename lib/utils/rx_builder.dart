import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

/// Reactive [StreamBuilder].
///
/// It has `data` ([ValueStream]) instead of `stream` ([Stream]).
///
/// `initialData` is optional. By default value of `initialData`
/// is taken from `data`s [ValueStream].
class RxBuilder<T> extends StreamBuilder<T> {
  /// Constructs an instance of [RxBuilder].
  RxBuilder({
    Key? key,
    ValueStream<T>? stream,
    T? initialData,
    required AsyncWidgetBuilder<T> builder,
  }) : super(
          key: key,
          initialData: initialData ?? stream?.value,
          stream: stream,
          builder: builder,
        );
}
