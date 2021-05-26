class RegisterUserRequest {
  String username;
  String password;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String langCode;
  String maxBetAmount;
  String maxDailyBetAmount;
  String address;
  String city;
  String countryCode;
  String email;
  String currencyName;
  String promoCode;
  String zipCode;
  String mobilePhone;
  bool subscribeToEmail;
  bool subscribeToSms;
  bool subscribeToBonus;

  RegisterUserRequest(
      this.username,
        this.password,
        this.firstName,
        this.lastName,
        this.gender,
        this.birthDate,
        this.langCode,
        this.maxBetAmount,
        this.maxDailyBetAmount,
        this.address,
        this.city,
        this.countryCode,
        this.email,
        this.currencyName,
        this.promoCode,
        this.zipCode,
        this.mobilePhone,
        this.subscribeToEmail,
        this.subscribeToSms,
        this.subscribeToBonus);

  RegisterUserRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    langCode = json['lang_code'];
    maxBetAmount = json['max_bet_amount'];
    maxDailyBetAmount = json['max_daily_bet_amount'];
    address = json['address'];
    city = json['city'];
    countryCode = json['country_code'];
    email = json['email'];
    currencyName = json['currency_name'];
    promoCode = json['promo_code'];
    zipCode = json['zip_code'];
    mobilePhone = json['mobile_phone'];
    subscribeToEmail = json['subscribe_to_email'];
    subscribeToSms = json['subscribe_to_sms'];
    subscribeToBonus = json['subscribe_to_bonus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['birth_date'] = this.birthDate;
    data['lang_code'] = this.langCode;
    data['max_bet_amount'] = this.maxBetAmount;
    data['max_daily_bet_amount'] = this.maxDailyBetAmount;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country_code'] = this.countryCode;
    data['email'] = this.email;
    data['currency_name'] = this.currencyName;
    data['promo_code'] = this.promoCode;
    data['zip_code'] = this.zipCode;
    data['mobile_phone'] = this.mobilePhone;
    data['subscribe_to_email'] = this.subscribeToEmail;
    data['subscribe_to_sms'] = this.subscribeToSms;
    data['subscribe_to_bonus'] = this.subscribeToBonus;
    return data;
  }
}