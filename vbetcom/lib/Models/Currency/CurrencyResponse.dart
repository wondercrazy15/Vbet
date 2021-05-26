import 'package:vbetcom/Common/Global.dart';

class CurrencyResponse {
  int code;
  String rid;
  CurrencyResponseData data;

  CurrencyResponse({this.code, this.rid, this.data});

  CurrencyResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    rid = json['rid'];
    data = json['data'] != null ? new CurrencyResponseData.fromJson(json['data']) : null;
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

class CurrencyResponseData {
  CurrencyResponseData1 data;

  CurrencyResponseData({this.data});

  CurrencyResponseData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CurrencyResponseData1.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CurrencyResponseData1 {
  CurrencyResponsePartner partner;

  CurrencyResponseData1({this.partner});

  CurrencyResponseData1.fromJson(Map<String, dynamic> json) {
    partner = json['partner'] != null ? new CurrencyResponsePartner.fromJson(json['partner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.partner != null) {
      data['partner'] = this.partner.toJson();
    }
    return data;
  }
}

class CurrencyResponsePartner {
  CurrencyResponseOne one;

  CurrencyResponsePartner({this.one});

  CurrencyResponsePartner.fromJson(Map<String, dynamic> json) {
    one = json[partnerId] != null ? new CurrencyResponseOne.fromJson(json[partnerId]) : null;
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (this.one != null) {
  data[partnerId] = this.one.toJson();
  }
  return data;
  }
}

class CurrencyResponseOne {
  List<String> supportedCurrencies;

  CurrencyResponseOne({this.supportedCurrencies});

  CurrencyResponseOne.fromJson(Map<String, dynamic> json) {
    supportedCurrencies = json['supported_currencies'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supported_currencies'] = this.supportedCurrencies;
    return data;
  }
}