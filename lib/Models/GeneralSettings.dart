class GeneralSettings {
  Data? data;
  String? message;

  GeneralSettings({this.data, this.message});

  GeneralSettings.fromJson(Map<String, dynamic> json) {
    print(json);
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? generalInfo;

  Data({this.generalInfo});

  Data.fromJson(Map<String, dynamic> json) {
    generalInfo = json['general_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['general_info'] = this.generalInfo;
    return data;
  }
}