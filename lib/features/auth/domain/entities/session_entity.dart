import 'package:shopping_app_task/features/auth/domain/entities/profile_entity.dart';

class Session {
  const Session({
    required this.profile,
    required this.accessToken,
    this.refreshToken = '',
    this.expiresAt,
    this.tokenUserId,
  });
  final Profile profile;
  final String accessToken, refreshToken;
  final DateTime? expiresAt;
  final String? tokenUserId;

  bool validAt(DateTime now) =>
      expiresAt != null &&
      tokenUserId == profile.id.toString() &&
      now.isBefore(expiresAt!);

  Session withProfile(Profile value) => Session(
    profile: value,
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
    tokenUserId: tokenUserId,
  );
}
