class UserData {
  String? token;
  String? tokenType;
  String? expiresAt;
  Data? data;
  String? role;

  UserData({this.token, this.tokenType, this.expiresAt, this.data, this.role});

  UserData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['role'] = role;
    return data;
  }
}

class Data {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? profilePic;
  String? status;
  String? regType;
  String? rewardPoints;
  String? createdAt;
  String? updatedAt;
  String? fullName;

  Data(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.phone,
        this.profilePic,
        this.status,
        this.regType,
        this.rewardPoints,
        this.createdAt,
        this.updatedAt,
        this.fullName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    profilePic = json['profile_pic'];
    status = json['status'];
    regType = json['reg_type'];
    rewardPoints = json['reward_points'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['profile_pic'] = profilePic;
    data['status'] = status;
    data['reg_type'] = regType;
    data['reward_points'] = rewardPoints;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['fullName'] = fullName;
    return data;
  }
}