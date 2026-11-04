import 'package:shopping_app_task/core/helper/dio/end_points.dart';
import 'package:shopping_app_task/core/helper/api/api_helper.dart';
import 'package:shopping_app_task/core/helper/dio/dio_exception.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app_task/features/auth/data/data_source/auth_api_service.dart';

abstract interface class CartApiService {
  Future<int> submitOrder(Session session, List<CartItem> items);
}

class DioCartApiService implements CartApiService {
  DioCartApiService(this.client, this.authApi);
  final ApiHelper client;
  final AuthApiService authApi;

  @override
  Future<int> submitOrder(Session session, List<CartItem> items) =>
      client.parse(() async {
        final profile = await authApi.me(session.accessToken);
        if (profile.id != session.profile.id) {
          throw const ApiFailure(
            'Session identity changed.',
            unauthorized: true,
          );
        }
        final json = (await client.postData<Map<String, dynamic>>(
          url: EndPoints.addCart,
          token: session.accessToken,
          data: {
            'userId': profile.id,
            'products': items
                .map((e) => {'id': e.product.id, 'quantity': e.quantity})
                .toList(),
          },
        )).data!;
        if (json['userId'] != profile.id || json['id'] is! num) {
          throw const FormatException('Invalid order confirmation');
        }
        return (json['id'] as num).toInt();
      });
}
