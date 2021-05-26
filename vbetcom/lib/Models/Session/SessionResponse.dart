class SessionResponse {
  int code;
  String rid;
  SessionResponseData data;
  String msg;

  SessionResponse(this.code, this.rid, this.data, this.msg);

  SessionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rid = json['rid'];
    data = json['data'] != null ? new SessionResponseData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['rid'] = this.rid;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class SessionResponseData {
  String sid;
  String host;
  String ip;
  int recaptchaVersion;
  bool recaptchaEnabled;
  String siteKey;
  Ctx ctx;

  SessionResponseData(
      {this.sid,
        this.host,
        this.ip,
        this.recaptchaVersion,
        this.recaptchaEnabled,
        this.siteKey,
        this.ctx});

  SessionResponseData.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    host = json['host'];
    ip = json['ip'];
    recaptchaVersion = json['recaptcha_version'];
    recaptchaEnabled = json['recaptcha_enabled'];
    siteKey = json['site_key'];
    ctx = json['ctx'] != null ? new Ctx.fromJson(json['ctx']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['host'] = this.host;
    data['ip'] = this.ip;
    data['recaptcha_version'] = this.recaptchaVersion;
    data['recaptcha_enabled'] = this.recaptchaEnabled;
    data['site_key'] = this.siteKey;
    if (this.ctx != null) {
      data['ctx'] = this.ctx.toJson();
    }
    return data;
  }
}

class Ctx {
  int site;
  String kType;
  String treeMode;

  Ctx({this.site, this.kType, this.treeMode});

  Ctx.fromJson(Map<String, dynamic> json) {
    site = json['site'];
    kType = json['k_type'];
    treeMode = json['tree_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site'] = this.site;
    data['k_type'] = this.kType;
    data['tree_mode'] = this.treeMode;
    return data;
  }
}