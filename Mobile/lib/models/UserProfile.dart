class UserProfile {
  String name;
  String? email;
  String username;
  bool is_parent;
  int points;
  int total_points;

  UserProfile(
    this.name, 
    this.email, 
    this.username, 
    this.is_parent,
    this.points, 
    this.total_points
    );
}