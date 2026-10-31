/// Base exception class for all networking and API failure scenarios.
abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const NetworkException(
    this.message, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;

  /// Factory helper that converts HTTP response status codes into specialized exceptions
  factory NetworkException.fromStatusCode(
    int statusCode, {
    String? message,
    dynamic details,
  }) {
    final defaultMsg = message ?? 'An HTTP error occurred ($statusCode)';
    switch (statusCode) {
      case 400:
        return BadRequestException(message ?? 'Invalid request parameters.', details);
      case 401:
        return UnauthorizedException(message ?? 'Session expired or unauthenticated.', details);
      case 403:
        return ForbiddenException(message ?? 'Access denied.', details);
      case 404:
        return NotFoundException(message ?? 'Requested resource was not found.', details);
      case 409:
        return ConflictException(message ?? 'A conflict occurred with existing data.', details);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(message ?? 'Server error. Please try again later.', statusCode, details);
      default:
        return UnexpectedException(defaultMsg, statusCode, details);
    }
  }

  /// Maps generic Dart/system exceptions into network exceptions
  factory NetworkException.fromException(Object error) {
    if (error is NetworkException) return error;
    final str = error.toString().toLowerCase();
    if (str.contains('socketexception') || str.contains('failed host lookup') || str.contains('network is unreachable')) {
      return const NoInternetException('No internet connection. Please check your network.');
    }
    if (str.contains('timeoutexception') || str.contains('timed out')) {
      return const ApiTimeoutException('Connection timed out. Please try again.');
    }
    return UnexpectedException('An unexpected error occurred: $error');
  }
}

class NoInternetException extends NetworkException {
  const NoInternetException([
    super.message = 'No internet connection detected.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class ApiTimeoutException extends NetworkException {
  const ApiTimeoutException([
    super.message = 'The server took too long to respond.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class BadRequestException extends NetworkException {
  const BadRequestException([
    super.message = 'Bad request.',
    dynamic details,
  ]) : super(statusCode: 400, details: details);
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException([
    super.message = 'Unauthorized request. Please log in.',
    dynamic details,
  ]) : super(statusCode: 401, details: details);
}

class ForbiddenException extends NetworkException {
  const ForbiddenException([
    super.message = 'Forbidden request.',
    dynamic details,
  ]) : super(statusCode: 403, details: details);
}

class NotFoundException extends NetworkException {
  const NotFoundException([
    super.message = 'Requested resource not found.',
    dynamic details,
  ]) : super(statusCode: 404, details: details);
}

class ConflictException extends NetworkException {
  const ConflictException([
    super.message = 'Conflict detected in request.',
    dynamic details,
  ]) : super(statusCode: 409, details: details);
}

class ServerException extends NetworkException {
  const ServerException([
    super.message = 'Internal server error occurred.',
    int? statusCode = 500,
    dynamic details,
  ]) : super(statusCode: statusCode ?? 500, details: details);
}

class UnexpectedException extends NetworkException {
  const UnexpectedException([
    super.message = 'An unexpected error occurred.',
    int? statusCode,
    dynamic details,
  ]) : super(statusCode: statusCode, details: details);
}
