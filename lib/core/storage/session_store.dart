import 'package:shopping_app_task/features/auth/data/models/session_model.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';

abstract interface class SessionStore {
  /// Reads the saved session
  Future<Session?> read();

  /// Stores the session securely
  Future<void> write(Session session);

  /// Removes the saved session
  Future<void> clear();
}

class SecureSessionStore implements SessionStore {
  /// Creates the secure session store
  SecureSessionStore({FlutterSecureStorage? storage})
    : secureStorage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage secureStorage;
  static const sessionStorageKey = 'dummy_shop.session.v1';

  /// Reads the saved session
  @override
  Future<Session?> read() async {
    final value = await secureStorage.read(key: sessionStorageKey);
    if (value == null) return null;
    try {
      return SessionModel.fromJson(
        jsonDecode(value) as Map<String, dynamic>,
      ).toEntity();
    } catch (_) {
      return null;
    }
  }

  /// Stores the session securely
  @override
  Future<void> write(Session session) => secureStorage.write(
    key: sessionStorageKey,
    value: jsonEncode(SessionModel.fromEntity(session).toJson()),
  );

  /// Removes the saved session
  @override
  Future<void> clear() => secureStorage.delete(key: sessionStorageKey);
}
