

class UserEntity {
  String updatedAt;
  String phone;
  String name;
  String createdAt;
  bool isFollowed;
  bool isFan;
  int id;

  //task 邀请中是否已接受邀请或已被邀请
  int isAccepted;

  UserEntity(
      {this.updatedAt,
      this.phone,
      this.name,
      this.createdAt,
      this.id,
      this.isFan,
      this.isFollowed});

  UserEntity.fromAuthJson(Map<String, dynamic> json) {
    updatedAt = json['updated_at'];
    phone = json['phone'];
    name = json['name'];
    createdAt = json['created_at'];
    id = json['id'];
    isFollowed = false;
    isFan = false;
    isAccepted = -1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserEntity && runtimeType == other.runtimeType && id == other.id;
}
