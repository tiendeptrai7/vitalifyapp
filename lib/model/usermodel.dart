
class User {
  User({
  required  this.userName,
  required  this.email,
  });

  String userName;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["userName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
      };
}
