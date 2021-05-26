class RegisterResponse {
  int code;
  String rid;
  RegisterResponseData data;

  RegisterResponse({this.code, this.rid, this.data});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rid = json['rid'];
    data = json['data'] != null ? new RegisterResponseData.fromJson(json['data']) : null;
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

class RegisterResponseData {
  dynamic result;
  String resultText;
  RegisterResponseDetails details;

  RegisterResponseData({this.result, this.resultText, this.details});

  RegisterResponseData.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    resultText = json['result_text'];
    details =
    json['details'] != null ? new RegisterResponseDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['result_text'] = this.resultText;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}

class RegisterResponseDetails {
  String username;
  String currencyName;
  int uid;
  int activeVerificationStep;
  String jweToken;

  RegisterResponseDetails(
      {this.username,
        this.currencyName,
        this.uid,
        this.activeVerificationStep,
        this.jweToken});

  RegisterResponseDetails.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    currencyName = json['currency_name'];
    uid = json['uid'];
    activeVerificationStep = json['active_verification_step'];
    jweToken = json['jwe_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['currency_name'] = this.currencyName;
    data['uid'] = this.uid;
    data['active_verification_step'] = this.activeVerificationStep;
    data['jwe_token'] = this.jweToken;
    return data;
  }
}