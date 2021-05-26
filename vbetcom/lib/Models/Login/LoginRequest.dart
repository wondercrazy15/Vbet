class LoginRequest {
  String rid;
  String command;
  LoginRequestParams params;

  LoginRequest(this.rid, this.command, this.params);

  LoginRequest.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    command = json['command'];
    params =
    json['params'] != null ? new LoginRequestParams.fromJson(json['params']) : null;
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

class LoginRequestParams {
  String username;
  String password;

  LoginRequestParams(this.username, this.password);

  LoginRequestParams.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}