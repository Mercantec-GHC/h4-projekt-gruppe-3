class User {
  int id;
  String name;
  String email;
  bool isParent = false;

  User(this.id, this.name, this.email, [this.isParent = false]);
}
