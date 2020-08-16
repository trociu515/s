class User {
  String id;
  String role;
  String username;
  String info;
  String authHeader;

  User();

  User create(Map<String, String> data) {
    id = data['id'];
    role = data['role'];
    username = data['username'];
    info = data['info'];
    authHeader = data['authorization'];
    return this;
  }
}
