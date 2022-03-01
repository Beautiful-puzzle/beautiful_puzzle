import 'errors/error.dart';

/// Model that wraps response from back-end response or fron-end validation
/// containing either result or error.
class Response<T> {
  /// Constructs an instance of [Response] from value.
  const Response.value(this.value) : error = null;

  /// Constructs an instance of [Response] from error.
  const Response.error(this.error) : value = null;

  /// Value aquired from back-end.
  final T? value;

  /// Error aquired from back-end response or front-end validation.
  final BaseError? error;

  /// Gets whther this [Response] has error or not.
  bool get hasError => error != null;
}
