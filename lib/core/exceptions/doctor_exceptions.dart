
class DoctorBlockedException implements Exception {
  final String message;

  DoctorBlockedException(this.message);

  @override
  String toString() => message;
}