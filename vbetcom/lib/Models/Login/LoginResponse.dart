class LoginResponse {
  int code;
  String rid;
  LoginResponseData data;

  LoginResponse({this.code, this.rid, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rid = json['rid'];
    data = json['data'] != null ? new LoginResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['rid'] = this.rid;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LoginResponseData {
  int userId;
  String authToken;
  dynamic qrCodeOrigin;
  int authenticationStatus;
  dynamic isNewClient;

  LoginResponseData(
      {this.userId,
        this.authToken,
        this.qrCodeOrigin,
        this.authenticationStatus,
        this.isNewClient});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    authToken = json['auth_token'];
    qrCodeOrigin = json['qr_code_origin'];
    authenticationStatus = json['authentication_status'];
    isNewClient = json['is_new_client'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['auth_token'] = this.authToken;
    data['qr_code_origin'] = this.qrCodeOrigin;
    data['authentication_status'] = this.authenticationStatus;
    data['is_new_client'] = this.isNewClient;
    return data;
  }
}
