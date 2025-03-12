class User {
  final int id;
  final int branchId;

  User({required this.id, required this.branchId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['userDetails']['id'],
      branchId: json['user']['userDetails']['branch_id'],
    );
  }
}
