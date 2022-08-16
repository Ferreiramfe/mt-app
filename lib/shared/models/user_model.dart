class UserModel {
  String email;
  String name;
  String type;

  UserModel(Map<String, dynamic> data) {
    email = data['email'];
    name = data['name'];
    type = data['type'];
  }
}