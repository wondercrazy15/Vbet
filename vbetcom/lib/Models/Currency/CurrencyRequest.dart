class CurrencyRequest {
  String rid;
  String command;
  CurrencyRequestParams params;

  CurrencyRequest({this.rid, this.command, this.params});

  CurrencyRequest.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    command = json['command'];
    params =
    json['params'] != null ? new CurrencyRequestParams.fromJson(json['params']) : null;
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

class CurrencyRequestParams {
  String source;
  CurrencyRequestWhat what;

  CurrencyRequestParams({this.source, this.what});

  CurrencyRequestParams.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    what = json['what'] != null ? new CurrencyRequestWhat.fromJson(json['what']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    if (this.what != null) {
      data['what'] = this.what.toJson();
    }
    return data;
  }
}

class CurrencyRequestWhat {
  List<String> partner;

  CurrencyRequestWhat({this.partner});

  CurrencyRequestWhat.fromJson(Map<String, dynamic> json) {
    if (json['partner'] != null) {
      partner = new List<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partner'] = new List<String>();
    return data;
  }
}


//class What {
//  List<Null> partner;
//
//  What({this.partner});
//
//  What.fromJson(Map<String, dynamic> json) {
//    if (json['partner'] != null) {
//      partner = new List<Null>();
//      json['partner'].forEach((v) {
//        partner.add(new Null.fromJson(v));
//      });
//    }
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.partner != null) {
//      data['partner'] = this.partner.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
//}
