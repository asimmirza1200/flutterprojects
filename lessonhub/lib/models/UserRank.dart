class UserRank {
  final int userId;
  final String userEmail;
  final String userName;
  final int startedAt;
  final int endedAt;
  final String score;
  final String total;

  UserRank({
    this.userId,
    this.userEmail,
    this.userName,
    this.startedAt,
    this.endedAt,
    this.score,
    this.total,
  });

  factory UserRank.fromJson(Map data) {
    return UserRank(
      userId: data["user_id"],
      userEmail: data["user"] == null ? data["user"] : data["user"]["email"],
      userName: data["user"] == null ? null : data["user"]["name"],
      startedAt: int.parse(data["started_at"]),
      endedAt: int.parse(data["ended_at"]),
      score: data["score"].toString(),
      total: data["total"].toString(),
    );
  }
}
