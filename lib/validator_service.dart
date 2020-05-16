class ValidatorService {

  static String validateLoginCredentials(String username, String password) {
    String invalidMessage;
    if (username.isEmpty && password.isEmpty) {
      invalidMessage = 'Nazwa użytkownika oraz hasło jest wymagane';
    } else if (username.isEmpty) {
      invalidMessage = 'Nazwa użytkownika jest wymagana';
    } else if (password.isEmpty) {
      invalidMessage = 'Hasło jest wymagane';
    }
    return invalidMessage;
  }
}
