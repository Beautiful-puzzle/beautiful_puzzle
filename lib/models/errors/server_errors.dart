import 'package:flutter/widgets.dart';

import 'error.dart';

/// Interface of Server-Level errors.
abstract class ServerError extends BaseError {
  /// Constructs an instance of [ServerError].
  ServerError(this.code, this.message);

  /// Code of the error.
  ///
  /// HTTP codes.
  final int? code;

  /// Message from server.
  final String? message;

  @override
  String localizedMessage(BuildContext context);
}
