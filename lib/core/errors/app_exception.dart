sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// No connection, DNS failure, timeout, etc.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Check your internet connection.']);
}

/// The server answered with a non-2xx status code.
class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

/// The response body could not be parsed into our models.
class ParsingException extends AppException {
  const ParsingException([super.message = 'Unexpected response format.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please log in again.',
  ]);
}
