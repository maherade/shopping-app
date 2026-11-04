import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/auth/domain/repo/auth_repo.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  /// Creates the auth cubit.
  AuthCubit(this.repository) : super(AuthInitial());
  final AuthRepository repository;
  Session? session;
  AuthStatus status = AuthStatus.restoring;
  bool offline = false;
  String? error;
  int requestGeneration = 0;

  /// Checks whether this request is current.
  bool isCurrentGeneration(int generation) =>
      !isClosed && generation == requestGeneration;

  /// Restores an eligible saved session.
  Future<void> restoreSession() async {
    final generation = ++requestGeneration;
    session = null;
    status = AuthStatus.restoring;
    offline = false;
    error = null;
    emit(AuthLoading());
    final response = await repository.restoreSession();
    if (!isCurrentGeneration(generation)) return;
    await response.fold<Future<void>>(
      (failure) async {
        status = AuthStatus.signedOut;
        error = failure.message;
        emit(AuthError());
      },
      (restored) async {
        final (savedSession, restoredOffline) = restored;
        final persistence = savedSession == null
            ? await repository.clearSession()
            : await repository.saveSession(savedSession);
        if (!isCurrentGeneration(generation)) return;
        persistence.fold(
          (failure) {
            status = AuthStatus.signedOut;
            error = failure.message;
            emit(AuthError());
          },
          (_) {
            session = savedSession;
            offline = restoredOffline;
            error = null;
            status = savedSession == null
                ? AuthStatus.signedOut
                : AuthStatus.authenticated;
            if (savedSession == null) {
              emit(AuthInitial());
            } else {
              emit(AuthSuccess());
            }
          },
        );
      },
    );
  }

  /// Signs in with the supplied credentials.
  Future<void> signIn(String username, String password) async {
    if (status == AuthStatus.loading) return;
    session = null;
    offline = false;
    if (username.trim().isEmpty || password.isEmpty) {
      status = AuthStatus.signedOut;
      error = 'Enter username and password.';
      emit(AuthError());
      return;
    }
    final generation = ++requestGeneration;
    status = AuthStatus.loading;
    error = null;
    emit(AuthLoading());
    final response = await repository.signIn(username.trim(), password);
    if (!isCurrentGeneration(generation)) return;
    await response.fold<Future<void>>(
      (failure) async {
        status = AuthStatus.signedOut;
        error = failure.message;
        emit(AuthError());
      },
      (authenticatedSession) async {
        final persistence = await repository.saveSession(authenticatedSession);
        if (!isCurrentGeneration(generation)) return;
        persistence.fold(
          (failure) {
            status = AuthStatus.signedOut;
            error = failure.message;
            emit(AuthError());
          },
          (_) {
            session = authenticatedSession;
            status = AuthStatus.authenticated;
            error = null;
            emit(AuthSuccess());
          },
        );
      },
    );
  }

  /// Signs out and clears the saved session.
  Future<void> signOut() async {
    final generation = ++requestGeneration;
    session = null;
    status = AuthStatus.signedOut;
    offline = false;
    error = null;
    emit(AuthInitial());
    final response = await repository.clearSession();
    if (!isCurrentGeneration(generation)) return;
    response.fold((failure) {
      error = failure.message;
      emit(AuthError());
    }, (_) {});
  }

  /// Invalidates pending requests and closes the Cubit.
  @override
  Future<void> close() {
    ++requestGeneration;
    return super.close();
  }
}
