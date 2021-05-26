class SessionRequest {
  String command;
  SessionRequestParams params;
  String rid;

  SessionRequest(this.command, this.params, this.rid);

  SessionRequest.fromJson(Map<String, dynamic> json) {
    command = json['command'];
    params =
    json['params'] != null ? new SessionRequestParams.fromJson(json['params']) : null;
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

class SessionRequestParams {
  String language;
  String siteId;

  SessionRequestParams(this.language, this.siteId);

  SessionRequestParams.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    siteId = json['site_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['site_id'] = this.siteId;
    return data;
  }
}