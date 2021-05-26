import 'RegisterUserRequest.dart';

class RegisterRequest {
  String rid;
  String command;
  RegisterRequestParams params;

  RegisterRequest(this.rid, this.command, this.params);

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    command = json['command'];
    params = json['params'] != null ? new RegisterRequestParams.fromJson(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rid'] = this.rid;
    data['command'] = this.command;
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    return data;
  }
}
// class RegisterRequestParams {
//   RegisterRequestUserInfo userInfo;
//
//   RegisterRequestParams(this.userInfo);
//
//   RegisterRequestParams.fromJson(Map<String, dynamic> json) {
//     userInfo = json['user_info'] != null
//         ? new RegisterRequestUserInfo.fromJson(json['user_info'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.userInfo != null) {
//       data['user_info'] = this.userInfo.toJson();
//     }
//     return data;
//   }
// }
class RegisterRequestParams {
  RegisterUserRequest userInfo;

  RegisterRequestParams(this.userInfo);

  RegisterRequestParams.fromJson(Map<String, dynamic> json) {
    userInfo = json['user_info'] != null
        ? new RegisterUserRequest.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
    return data;
  }
}

class RegisterRequestUserInfo {
  String username;
  String password;
  String countryCode;
  String email;
  String currencyName;
  String promoCode;
  int siteId;
  String activeTimeInCasino;
  String langCode;
  bool tccheckbox;

  RegisterRequestUserInfo(
      this.username,
        this.password,
        this.countryCode,
        this.email,
        this.currencyName,
        this.promoCode,
        this.siteId,
        this.activeTimeInCasino,
        this.langCode,
        this.tccheckbox);

  RegisterRequestUserInfo.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    countryCode = json['country_code'];
    email = json['email'];
    currencyName = json['currency_name'];
    promoCode = json['promo_code'];
    siteId = json['siteId'];
    activeTimeInCasino = json['active_time_in_casino'];
    langCode = json['lang_code'];
    tccheckbox = json['tccheckbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['country_code'] = this.countryCode;
    data['email'] = this.email;
    data['currency_name'] = this.currencyName;
    data['promo_code'] = this.promoCode;
    data['siteId'] = this.siteId;
    data['active_time_in_casino'] = this.activeTimeInCasino;
    data['lang_code'] = this.langCode;
    data['tccheckbox'] = this.tccheckbox;
    return data;
  }
}