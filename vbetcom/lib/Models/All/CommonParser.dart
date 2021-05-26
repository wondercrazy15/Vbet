class CommonParser {
  int code;
  String rid;
  String msg;

  CommonParser({this.code, this.rid, this.msg});

  CommonParser.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rid = json['rid'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['rid'] = this.rid;
    data['msg'] = this.msg;
    return data;
  }
}