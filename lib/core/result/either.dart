sealed class Either<Failure, Value> {
  const Either();

  Result fold<Result>(
    Result Function(Failure failure) onFailure,
    Result Function(Value value) onSuccess,
  );

  bool get isLeft => this is Left<Failure, Value>;

  bool get isRight => this is Right<Failure, Value>;
}

final class Left<Failure, Value> extends Either<Failure, Value> {
  const Left(this.failure);
  final Failure failure;

  @override
  Result fold<Result>(
    Result Function(Failure failure) onFailure,
    Result Function(Value value) onSuccess,
  ) => onFailure(failure);
}

final class Right<Failure, Value> extends Either<Failure, Value> {
  const Right(this.value);
  final Value value;

  @override
  Result fold<Result>(
    Result Function(Failure failure) onFailure,
    Result Function(Value value) onSuccess,
  ) => onSuccess(value);
}
