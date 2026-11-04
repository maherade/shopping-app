part of 'auth_cubit.dart';

enum AuthStatus { restoring, signedOut, loading, authenticated }

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthError extends AuthState {}
