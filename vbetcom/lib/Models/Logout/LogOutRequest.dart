class LogOutRequest {
  String command;

  LogOutRequest(this.command);

  LogOutRequest.fromJson(Map<String, dynamic> json) {
    command = json['command'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['command'] = this.command;
    return data;
  }
}