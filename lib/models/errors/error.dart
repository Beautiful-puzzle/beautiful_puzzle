import 'package:flutter/widgets.dart';

/// Interface of base error.
abstract class BaseError implements Exception {
  /// Checks whether provided error is [BaseError] ancestor, if yes
  /// [e] will be returned as [BaseError], otherwise it will be wrapped
  /// with [UnknownError].
  static BaseError fromDynamic(dynamic e) =>
      e is BaseError ? e : UnknownError(e);

  /// Gets localized error message.
  String localizedMessage(BuildContext context);
}

/// Unknown error.
class UnknownError extends BaseError {
  /// Constructs an instance of [UnknownError].
  UnknownError(this.internalError);

  /// Internal error or exception.
  final dynamic internalError;

  @override
  String localizedMessage(BuildContext context) {
    // TODO: localize
    return 'Unkown error';
  }
}
