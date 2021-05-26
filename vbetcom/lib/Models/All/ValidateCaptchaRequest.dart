class ValidateCaptchaRequest {
  String command;
  ValidateCaptchaRequestParams params;
  String rid;

  ValidateCaptchaRequest({this.command, this.params, this.rid});

  ValidateCaptchaRequest.fromJson(Map<String, dynamic> json) {
    command = json['command'];
    params = json['params'] != null ? new ValidateCaptchaRequestParams.fromJson(json['params']) : null;
    rid = json['rid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.command;
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    data['rid'] = this.rid;
    return data;
  }
}

class ValidateCaptchaRequestParams {
  String mHash;

  ValidateCaptchaRequestParams({this.mHash});

  ValidateCaptchaRequestParams.fromJson(Map<String, dynamic> json) {
    mHash = json['m_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m_hash'] = this.mHash;
    return data;
  }
}
