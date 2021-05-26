class ValidateCaptchaResponse {
  int code;
  String rid;
  dynamic data;

  ValidateCaptchaResponse({this.code, this.rid, this.data});

  ValidateCaptchaResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rid = json['rid'];
    try{
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    }catch(exce){
      data = json['data'];
    }
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

class Data {
  bool result;
  Null resultText;
  Null details;

  Data({this.result, this.resultText, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    result = json['result'];
//    resultText = json['result_text'];
//    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
//    data['result_text'] = this.resultText;
//    data['details'] = this.details;
    return data;
  }
}
