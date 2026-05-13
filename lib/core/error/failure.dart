abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DataFailure extends Failure {
  const DataFailure(super.message);
}
