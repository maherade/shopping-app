import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';
import 'package:shopping_app_task/core/result/repository_result.dart';
import 'package:shopping_app_task/features/auth/domain/repo/auth_repo.dart';
import 'package:shopping_app_task/features/auth/data/data_source/auth_api_service.dart';
import 'package:shopping_app_task/core/storage/session_store.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';

class AuthRepoImp implements AuthRepository {
  AuthRepoImp(this.authApi, this.sessionStore, {DateTime Function()? now})
    : now = now ?? DateTime.now;
  final AuthApiService authApi;
  final SessionStore sessionStore;
  final DateTime Function() now;
  Future<void> pendingWrites = Future.value();

  Future<void> serializeSessionWrite(Future<void> Function() action) {
    final queuedWrite = pendingWrites.then((_) => action());
    pendingWrites = queuedWrite.then(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
    return queuedWrite;
  }

  @override
  Future<Either<ApiFailure, Session>> signIn(
    String username,
    String password,
  ) async {
    final response = await repositoryResult(
      () => authApi.login(username, password),
      failureMessage: 'Cannot save your session securely. Please retry.',
    );
    return response.fold(
      (failure) => Left(failure),
      (sessionModel) => Right(sessionModel.toEntity()),
    );
  }

  @override
  Future<Either<ApiFailure, (Session?, bool)>> restoreSession() async {
    await pendingWrites;
    final response = await repositoryResult(
      sessionStore.read,
      failureMessage: 'Cannot restore your saved session. Retry or sign in.',
    );
    return response.fold<Future<Either<ApiFailure, (Session?, bool)>>>(
      (failure) async => Left(failure),
      (savedSession) async {
        if (savedSession == null || !savedSession.validAt(now())) {
          return const Right((null, false));
        }
        final profileResponse = await repositoryResult(
          () => authApi.me(savedSession.accessToken),
          failureMessage:
              'Cannot restore your saved session. Retry or sign in.',
        );
        if (!savedSession.validAt(now())) {
          return const Right((null, false));
        }
        return profileResponse.fold(
          (failure) {
            if (failure.network && savedSession.validAt(now())) {
              return Right((savedSession, true));
            }
            if (failure.unauthorized) return const Right((null, false));
            return Left(failure);
          },
          (profileModel) => profileModel.id != savedSession.profile.id
              ? const Right((null, false))
              : Right((
                  savedSession.withProfile(profileModel.toEntity()),
                  false,
                )),
        );
      },
    );
  }

  @override
  Future<Either<ApiFailure, void>> saveSession(Session session) async {
    final response = await repositoryResult(
      () => serializeSessionWrite(() => sessionStore.write(session)),
      failureMessage: 'Cannot save your session securely. Please retry.',
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<ApiFailure, void>> clearSession() async {
    final response = await repositoryResult(
      () => serializeSessionWrite(sessionStore.clear),
      failureMessage:
          'Could not remove the saved session. Retry signing out before closing the app.',
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
