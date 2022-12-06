class NoteModel {
  int? id;
  String? userId;
  String? title;
  String? description;
  String? reference;
  int? uploaded;

  String? createdAt;
  String? updatedAt;

  NoteModel(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.reference,
      this.uploaded,
      this.createdAt,
      this.updatedAt});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    reference = json['reference'];
    uploaded = json['uploaded'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['reference'] = reference;
    data['uploaded'] = uploaded;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
