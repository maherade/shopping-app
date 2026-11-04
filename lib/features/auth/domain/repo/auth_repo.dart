import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';

abstract interface class AuthRepository {
  Future<Either<ApiFailure, Session>> signIn(String username, String password);

  Future<Either<ApiFailure, (Session?, bool)>> restoreSession();

  Future<Either<ApiFailure, void>> saveSession(Session session);

  Future<Either<ApiFailure, void>> clearSession();
}
