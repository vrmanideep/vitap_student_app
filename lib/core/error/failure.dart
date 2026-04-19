class Failure {
  final String message;
  Failure([this.message = 'An unexpected error occurred,']);
}

class LoginOtpRequiredFailure extends Failure {
  LoginOtpRequiredFailure() : super('OTP verification is required for login.');
}
