abstract class Failure implements Exception {
  @override
  String toString() => '$runtimeType Exception';
}

// General failures
class GenericFailure extends Failure {
  final dynamic reason;

  GenericFailure(this.reason);

  @override
  String toString() => '$runtimeType: $reason';
}

class APIFailure extends Failure {}

abstract class Result<S> {
  static Result<S> failure<S>(Failure failure) => FailureResult(failure);
  static Result<S> success<S>(S data) => SuccessResult(data);

  /// Get [error] value, returns null when the value is actually [data]
  Failure? get error;

  /// Get [data] value, returns null when the value is actually [error]
  S? get data;

  /// Returns `true` if the object is of the `SuccessResult` type, which means
  /// `data` will return a valid result.
  bool get isSuccess;

  /// Returns `true` if the object is of the `FailureResult` type, which means
  /// `error` will return a valid result.
  bool get isFailure;

  /// Returns `data` if `isSuccess` returns `true`, otherwise it returns
  /// `other`.
  S dataOrElse(S other);
}

class FailureResult<S> extends Result<S> {
  final Failure failure;

  FailureResult(this.failure);

  @override
  Failure get error => failure;

  @override
  bool get isFailure => true;

  @override
  bool get isSuccess => false;

  @override
  dataOrElse(other) => other;

  @override
  get data => throw UnimplementedError();
}

class SuccessResult<S> extends Result<S> {
  @override
  S data;

  SuccessResult(this.data);

  @override
  Failure? get error => null;

  @override
  bool get isFailure => false;

  @override
  bool get isSuccess => true;

  @override
  dataOrElse(other) => data;
}

abstract class Response<T> extends Result<T> {
  int get statusCode;
  String get statusMessage;

  @override
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  @override
  bool get isFailure => statusCode >= 400 && statusCode < 600;

  static Response<T> success<T>(T data) =>
      SuccessResponse(200, "Success", data);
  static Response<T> fail<T>(error) =>
      FailureResponse(499, "Client Error", error);
  static Response<T> failByClient<T>(Failure error) =>
      FailureResponse(400, "Client Error", error);
  static Response<T> failByServer<T>(Failure error) =>
      FailureResponse(500, "Server Error", error);

  isClientFailure() => statusCode >= 400 && statusCode < 500;
  isServerFailure() => statusCode >= 500 && statusCode < 600;
}

class SuccessResponse<T> extends Response<T> {
  @override
  final int statusCode;
  @override
  final String statusMessage;
  @override
  final T data;

  SuccessResponse(this.statusCode, this.statusMessage, this.data);

  @override
  Failure? get error => null;

  @override
  T dataOrElse(T other) {
    return data ?? other;
  }
}

class FailureResponse<T> extends Response<T> {
  @override
  final int statusCode;
  @override
  final String statusMessage;
  @override
  final Failure error;

  FailureResponse(this.statusCode, this.statusMessage, this.error);

  @override
  T? get data => null;

  @override
  T dataOrElse(T other) {
    return other;
  }
}
