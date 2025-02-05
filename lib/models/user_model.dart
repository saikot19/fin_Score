class UserModel {
  final int id;
  final int branchId;
  final int status;
  final String message;

  UserModel({
    required this.id,
    required this.branchId,
    required this.status,
    required this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userDetails']['id'],
      branchId: json['userDetails']['branch_id'],
      status: json['status'],
      message: json['msg'],
    );
  }
}
