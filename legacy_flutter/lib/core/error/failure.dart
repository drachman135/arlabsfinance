/// Failure class for domain layer error representation.
///
/// Used in the domain layer to represent errors without
/// exposing data-layer exception details.
sealed class Failure {
  const Failure({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timed out'});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred'});
}
