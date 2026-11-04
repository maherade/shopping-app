import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';

Future<Either<ApiFailure, Value>> repositoryResult<Value>(
  Future<Value> Function() action, {
  required String failureMessage,
}) async {
  try {
    return Right(await action());
  } on ApiFailure catch (error) {
    return Left(error);
  } catch (_) {
    return Left(UnexpectedFailure(failureMessage));
  }
}
