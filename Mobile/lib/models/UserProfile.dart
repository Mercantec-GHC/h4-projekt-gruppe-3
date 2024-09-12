class UserProfile {
  int id;
  String name;
  String? email;
  String username;
  bool is_parent;
  int points;
  int total_points;

  UserProfile(
    this.id,
    this.name,
    this.email, 
    this.username, 
    this.is_parent,
    this.points, 
    this.total_points
    );
}
