import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';

abstract interface class CartRepository {
  Future<Either<ApiFailure, List<CartItem>>> loadCart(int userId);

  Future<Either<ApiFailure, void>> saveCart(int userId, List<CartItem> items);

  Future<Either<ApiFailure, int>> submitOrder(
    Session session,
    List<CartItem> items,
  );
}
