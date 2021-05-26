import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vbetcom/Models/All/ValidateCaptchaRequest.dart';
import 'package:vbetcom/Models/Session/SessionRequest.dart';
import 'package:web_socket_channel/io.dart';

Color themeBlue = Color.fromRGBO(0x1D, 0x18, 0x4E, 1);//1D184E
Color themePink = Color.fromRGBO(0xD8, 0x29, 0x8F, 1);//D8298F
Color themeGreen = Color.fromRGBO(0x3A, 0xA1, 0x88, 1);//3AA188
Color themeWhite = Color.fromRGBO(0xFF, 0xFF, 0xFF, 1);
Color themeBlueLight = Color.fromRGBO(0x3E, 0x39, 0x71, 1);//3E3782

FontWeight semiBold = FontWeight.w600;

final String websocketUrl = 'wss://eu-swarm-springre.betconstruct.com';
//'wss://eu-swarm-springre.betconstruct.com';

final String cmdId = "8485";
final String cmdRequestSession = "request_session";
final String cmdRemoveSession = "remove_session";
final String cmdRegisterUser = "register_user";
final String cmdLoginUser = "login";
final String cmdGetCurrency = "get";
final String cmdLogout = "logout";
final String cmdValidateCaptcha = "validate_recaptcha";

final String keyUserRegistrationData = "RegisteredUserData";
final String keyUserLoggedInData = "LoggedInUserData";


final String keyIsUserLogin = "IsUserLoggedIn";

final String partnerId = "333";  //1872532 //1874814

SharedPreferences AppPreferences;


startSession(IOWebSocketChannel channel) {
  SessionRequestParams params = SessionRequestParams("eng", partnerId);
  SessionRequest requestSession = SessionRequest(cmdRequestSession, params, cmdRequestSession + cmdId);
  channel.sink.add(jsonEncode(requestSession));
}

void stopSession(IOWebSocketChannel channel) {
  SessionRequest requestSession = SessionRequest(cmdRemoveSession, null, cmdRemoveSession+cmdId);
  channel.sink.add(jsonEncode(requestSession));
}

MaterialColor themeMaterialGreen = const MaterialColor(0xFF3AA188,
    const {
      50 : const Color(0xFF3AA188),
      100 : const Color(0xFF3AA188),
      200 : const Color(0xFF3AA188),
      300 : const Color(0xFF3AA188),
      400 : const Color(0xFF3AA188),
      500 : const Color(0xFF3AA188),
      600 : const Color(0xFF3AA188),
      700 : const Color(0xFF3AA188),
      800 : const Color(0xFF3AA188),
      900 : const Color(0xFF3AA188)}
);

MaterialColor themeMaterialBlue = const MaterialColor(0xFF1D184E,
    const {
      50 : const Color(0xFF1D184E),
      100 : const Color(0xFF1D184E),
      200 : const Color(0xFF1D184E),
      300 : const Color(0xFF1D184E),
      400 : const Color(0xFF1D184E),
      500 : const Color(0xFF1D184E),
      600 : const Color(0xFF1D184E),
      700 : const Color(0xFF1D184E),
      800 : const Color(0xFF1D184E),
      900 : const Color(0xFF1D184E)}
      );

Widget getLoader(){
  return SpinKitChasingDots(//SpinKitWanderingCubes
    color: themePink,
    size: 50.0,
  );
}

String countryCodeToEmoji(String countryCode) {
  // 0x41 is Letter A
  // 0x1F1E6 is Regional Indicator Symbol Letter A
  // Example :
  // firstLetter U => 20 + 0x1F1E6
  // secondLetter S => 18 + 0x1F1E6
  // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
  final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}

showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themePink,
      textColor: Colors.white,
      fontSize: 17.0
  );
}

isValidEmail(String email){
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}

//MD5 Hash Conversion
String md5Hashing(String sid){

  Hash hasher = md5;
  String key = "c4c824e3-6f76-413d-871d-306efa567e4b";

  String dataString = "SESSION" + sid + "KEY" + key;
  var bytes = utf8.encode(dataString);
  var digest = hasher.convert(bytes);

  print("Digest as hex string: $digest");

  ValidateCaptchaRequestParams validateCaptchaParams = ValidateCaptchaRequestParams(
      mHash: digest.toString()
  );

  ValidateCaptchaRequest validateCaptchaRequest = ValidateCaptchaRequest(command: cmdValidateCaptcha,params: validateCaptchaParams, rid: cmdValidateCaptcha+cmdId);
  String json = jsonEncode(validateCaptchaRequest);
  return json;
}