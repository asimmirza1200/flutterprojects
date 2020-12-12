class AppUser {
  final int id;
  final String name;
  final String username;
  final String email;
  final DateTime lastVisitDate;

  AppUser({this.id, this.name, this.username, this.email, this.lastVisitDate});

  factory AppUser.fromJson(Map user) {
    return AppUser(
      id: user["id"],
      name: user["name"],
      username: user["username"],
      email: user["email"],
      lastVisitDate: user["lastVisitDate"],
    );
  }
}
