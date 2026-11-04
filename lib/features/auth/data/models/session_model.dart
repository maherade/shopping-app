import 'dart:convert';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';
import 'package:shopping_app_task/features/auth/data/models/profile_model.dart';

class SessionModel extends Session {
  SessionModel({
    required super.profile,
    required super.accessToken,
    super.refreshToken,
  }) : super(
         expiresAt: parseTokenExpiry(accessToken),
         tokenUserId: parseTokenSubject(accessToken),
       );

  static Map<String, dynamic> parseTokenClaims(String token) {
    try {
      return jsonDecode(
            utf8.decode(
              base64Url.decode(base64Url.normalize(token.split('.')[1])),
            ),
          )
          as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static DateTime? parseTokenExpiry(String token) {
    final expiry = parseTokenClaims(token)['exp'];
    try {
      return expiry is num && expiry.isFinite
          ? DateTime.fromMillisecondsSinceEpoch((expiry * 1000).ceil())
          : null;
    } catch (_) {
      return null;
    }
  }

  static String? parseTokenSubject(String token) {
    final claims = parseTokenClaims(token);
    return (claims['id'] ?? claims['sub'])?.toString();
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    profile: ProfileModel.fromJson(
      json['profile'] as Map<String, dynamic>,
    ).toEntity(),
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String? ?? '',
  );

  factory SessionModel.fromEntity(Session value) => SessionModel(
    profile: value.profile,
    accessToken: value.accessToken,
    refreshToken: value.refreshToken,
  );

  Map<String, dynamic> toJson() => {
    'profile': ProfileModel.fromEntity(profile).toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  Session toEntity() => Session(
    profile: ProfileModel.fromEntity(profile).toEntity(),
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
    tokenUserId: tokenUserId,
  );
}
