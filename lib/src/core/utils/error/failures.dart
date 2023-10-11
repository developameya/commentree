import 'package:equatable/equatable.dart';

/// Failures abstract class for List of properties failures
abstract class Failure extends Equatable {
  final String? message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [];
}

/// General Failures
/// this class is used to show Server Failures
class ServerFailure extends Failure {
  const ServerFailure({String? message}) : super(message: message ?? '');
}

/// this class is used to show cache failures
class CacheFailure extends Failure {
  const CacheFailure({String? message}) : super(message: message ?? '');
}

/// this class is used to show various validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({String? message}) : super(message: message ?? '');
}
