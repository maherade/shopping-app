import 'package:shopping_app_task/core/helper/dio/end_points.dart';
import 'package:shopping_app_task/core/helper/api/api_helper.dart';
import 'package:shopping_app_task/features/auth/data/models/profile_model.dart';
import 'package:shopping_app_task/features/auth/data/models/session_model.dart';

abstract interface class AuthApiService {
  Future<SessionModel> login(String username, String password);

  Future<ProfileModel> me(String token);
}

class DioAuthApiService implements AuthApiService {
  DioAuthApiService(this.client);
  final ApiHelper client;

  @override
  Future<SessionModel> login(String username, String password) => client.parse(
    () async {
      final json = (await client.postData<Map<String, dynamic>>(
        url: EndPoints.login,
        data: {'username': username, 'password': password, 'expiresInMins': 60},
      )).data!;
      final token = json['accessToken'] as String;
      final profile = await me(token);
      if (profile.id != (json['id'] as num).toInt()) {
        throw const FormatException('Identity mismatch');
      }
      return SessionModel(
        profile: profile,
        accessToken: token,
        refreshToken: json['refreshToken'] as String? ?? '',
      );
    },
  );

  @override
  Future<ProfileModel> me(String token) => client.parse(
    () async => ProfileModel.fromJson(
      (await client.getData<Map<String, dynamic>>(
        url: EndPoints.me,
        token: token,
      )).data!,
    ),
  );
}
