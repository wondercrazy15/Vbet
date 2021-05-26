import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/Models/All/CommonParser.dart';
import 'package:vbetcom/Models/All/ValidateCaptchaResponse.dart';
import 'package:vbetcom/Models/Currency/CurrencyRequest.dart';
import 'package:vbetcom/Models/Currency/CurrencyResponse.dart';
import 'package:vbetcom/Models/Logout/LogOutRequest.dart';
import 'package:vbetcom/Models/Register/RegisterRequest.dart';
import 'package:vbetcom/Models/Register/RegisterResponse.dart';
import 'package:vbetcom/Models/Register/RegisterUserRequest.dart';
import 'package:vbetcom/Models/Session/SessionRequest.dart';
import 'package:vbetcom/Models/Session/SessionResponse.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/UIComponents/stepper.dart';
import 'package:vbetcom/Views/Home/DashboardView.dart';
import 'package:vbetcom/Views/HomeView.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';
import 'package:vbetcom/Views/StartUp/StartUpView.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'SignUPView1.dart';
import 'SignUpView2.dart';
import 'SignUpView3.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  Stream broadcastStream;
  IOWebSocketChannel channel;
  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
  @override
  void initState() {
    // TODO: implement initState

    channel = IOWebSocketChannel.connect(websocketUrl);
    broadcastStream = channel.stream.asBroadcastStream();
    startSession(channel);

    super.initState();
  }

  List<String> listCurrency = List<String>();
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
    stopSession(channel);
    channel.sink.close();
    mapData["loading"]="false";
    if(!recaptchaV2Controller.isDisposed){
      recaptchaV2Controller.dispose();
    }
  }

  TextEditingController txtUserName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtCountry = TextEditingController();
  TextEditingController txtCurrency = TextEditingController();
  TextEditingController txtPromoCode = TextEditingController();

  bool isAgree = false;
  bool isPasswordObscure = true;
  bool IsCaptchaVerified = false;
  var currentStep = 0;
  //int currStep = 0;

  List<Step> steps;
  bool _ISFirstStepActive=true;
  bool _ISSecondStepActive=false;
  bool _ISThirdStepActive=false;

  void UpdateSteps(int step) {
    setState(() {
      currentStep = step;
      steps[currentStep].isActive=true;
      if(currentStep==0)
      {
        _ISFirstStepActive=true;
        _ISSecondStepActive=false;
        _ISThirdStepActive=false;
      }
      else if(currentStep==1)
      {
        _ISFirstStepActive=true;
        _ISSecondStepActive=true;
        _ISThirdStepActive=false;
      }
      if(currentStep==2)
      {
        _ISFirstStepActive=true;
        _ISSecondStepActive=true;
        _ISThirdStepActive=true;
      }
    });
  }
  var mapData = HashMap<String, String>();
  @override
  Widget build(BuildContext context) {
    GlobalKey<SignUpView1State> textGlobalKey = new GlobalKey<SignUpView1State>();

    mapData["username"] = SignUpView1State.txtUserName.text;
    mapData["first_name"] = SignUpView1State.txtFirstName.text;
    mapData["last_name"] = SignUpView1State.txtLastName.text;
    mapData["email"] = SignUpView1State.txtEmail.text;
    mapData["password"] = SignUpView1State.txtPassword.text;
    mapData["currency_name"] = SignUpView1State.txtCurrency.text;
    mapData["birth_date"] = SignUpView2State.dateController.text;
    mapData["zip_code"] = SignUpView2State.txtPostcode.text;
    mapData["city"] = SignUpView2State.txtCity.text;
    mapData["address"] = SignUpView2State.txtAddress.text;
    mapData["mobile_phone"] = SignUpView2State.txtMobileNo.text;
    mapData["max_daily_bet_amount"] = SignUpView2State.txtDailyDeposit.text;
    mapData["max_weekly_bet_amount"] = SignUpView2State.txtWeeklyDeposit.text;
    mapData["max_monthly_bet_amount"] = SignUpView2State.txtMonthlyDeposit.text;
    mapData["country"] = SignUpView2State.txtCountry.text;
    mapData["country_code"] = SignUpView2State.txtCountryCode.text;
    mapData["Phone_code"] = SignUpView2State.txtselectedPhoneCode.text;
    mapData["gender"] = SignUpView2State.txtGender.text;
    mapData["promo_code"] = SignUpView3State.txtPromoCode.text;
    mapData["loading"] = SignUpView3State.txtloader.text;

    // mapData["last_name"] = SignUpView1State.controllerLastName.text;
    // mapData["date_of_birth"] = SignUpView1State.controllerDateOfBirth.text;
    // mapData["gender"] = SignUpView1State.controllerGender.text;

    steps = [
      Step(
        title: Text(''),
        content: SignUpView1(currentStep: currentStep,key: textGlobalKey,function: UpdateSteps,listCurrency:listCurrency),
        state:  StepState.indexed,
        isActive: _ISFirstStepActive,
      ),
      Step(
        title: Text(''),
        content: SignUpView2(currentStep: currentStep,key: textGlobalKey,function: UpdateSteps),
        state:   StepState.indexed,
        isActive: _ISSecondStepActive,
      ),
      Step(
        title: Text(''),
        content: SignUpView3(mapData,currentStep: currentStep,key: textGlobalKey,function: UpdateSteps,channel:channel,broadcastStream: broadcastStream,isLoading:isLoading),
        state: StepState.indexed,
        isActive: _ISThirdStepActive,
      ),
    ];


    FocusNode focusNode = FocusNode();
    return Container(
      color: themeBlue,
      child: SafeArea(
        child: Scaffold(
          body: KeyboardDismisser(
            gestures: [
              GestureType.onTap,
              GestureType.onPanUpdateDownDirection,
              GestureType.onPanDown
            ],
            child: ModalProgressHUD(
              inAsyncCall: isLoading,
              color: themeBlue,
              progressIndicator: getLoader(),
              opacity: 1,
              child: StreamBuilder(
                stream: broadcastStream,
                builder: (context, snapshot) {
                  //Loading Stuff
                  if (!snapshot.hasData) {

                    if (snapshot.data != null && snapshot.data.length == 0) {
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = false;
                        setState(() {});
                      });
                    } else {
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = true;
                        setState(() {});
                      });
                      return Container();
                    }
                  }
                  else {
                    if (isLoading) {
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = false;
                        setState(() {});
                      });
                    }
                  }
                  print("Connection State: " +
                      snapshot.connectionState.toString());

                  if (snapshot.hasError) {
                    print("Error: " + snapshot.error.toString());
                  }
                  var isload=mapData["loading"];
                  if(isload=="true")isLoading=true;
                  CommonParser parser =
                  CommonParser.fromJson(jsonDecode(snapshot.data));
//              if(parser.code == 5){
//                stopSession(channel);
//                  channel = IOWebSocketChannel.connect(websocketUrl);
//                  broadcastStream = channel.stream.asBroadcastStream();

//                startSession(channel);
//              }
                  print("Data: " + snapshot.data.toString());

                  if (snapshot.hasData) {

                    CommonParser parser =
                    CommonParser.fromJson(jsonDecode(snapshot.data));

                    if (parser.rid == cmdGetCurrency + cmdId) {
                      if (parser.code == 0) {
                        CurrencyResponse currencyResponse =
                        CurrencyResponse.fromJson(
                            jsonDecode(snapshot.data));
                        List<String> currencyList;
                        try {
                          currencyList = currencyResponse
                              .data.data.partner.one.supportedCurrencies;
                        } catch (exc) {
                          currencyList = List<String>();
                        }
                        listCurrency = List<String>();
                        for (int i = 0; i < currencyList.length; i++) {
                          listCurrency.add(currencyList[i]);
                        }
                      } else {
                        showToast(parser.msg);
                      }
                    } else if (parser.rid == cmdRegisterUser + cmdId) {
                      if (parser.code == 0) {
                        RegisterResponse registerResponse =
                        RegisterResponse.fromJson(
                            jsonDecode(snapshot.data));
                        if (registerResponse.data.result
                            .toString()
                            .toLowerCase() ==
                            "ok") {
                          AppPreferences.setString(
                              keyUserRegistrationData, snapshot.data);
                          AppPreferences.setBool(keyIsUserLogin, true);

                          new Future.delayed(new Duration(milliseconds: 0), () {
                            showToast("Register successful");
                            stopSession(channel);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeView()));
                          });
                        } else {
                          if (isLoading) {
                            mapData["loading"]="flase";
                            showToast(registerResponse.data.resultText);
                            isLoading = false;
                          }
                        }
                      } else {
                        if (isLoading) {
                          showToast(parser.msg);
                          mapData["loading"]="flase";
                          isLoading = false;
                        }
                      }
                    } else if (parser.rid == cmdRequestSession + cmdId) {
                      getCurrencyList();
                      SessionResponse requestSessionResponse =
                      SessionResponse.fromJson(jsonDecode(snapshot.data));
                      String json = md5Hashing(requestSessionResponse.data.sid);
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = true;
                        setState(() {});
                      });
                      channel.sink.add(json);
                    } else if (parser.rid == cmdValidateCaptcha + cmdId) {
                      try {
                        ValidateCaptchaResponse validateCaptchaResponse =
                        ValidateCaptchaResponse.fromJson(
                            jsonDecode(snapshot.data));
                        if (validateCaptchaResponse != null &&
                            validateCaptchaResponse.data != null &&
                            validateCaptchaResponse.data.result == false) {
                          showToast("Something went wrong, Try again later");
                        }
                      } catch (ex) {
                        showToast("Something went wrong, Try again later");
                      }
                    }
                    print("Data: " + snapshot.data.toString());
                  }
                  return Container(
                      color: themeBlue,
                      child: SingleChildScrollView(
                          child: Container(
                              color: themeBlue,
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  Column(children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(top: 50),
                                            child: Column(children: [
                                              Center(
                                                child: Container(
                                                  width: 128,
                                                  height: 48,
                                                  child: Image.asset(
                                                      'assets/images/vbet_logo.png'),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 35,
                                              ),
                                              Expanded(
                                                child:Theme(
                                                  data: ThemeData(
                                                    primarySwatch: themeMaterialGreen,
                                                    accentColor: themeMaterialGreen,
                                                  ),
                                                  child:  Stepper(
                                                      physics:ClampingScrollPhysics(),
                                                      type: StepperType.horizontal,
                                                      currentStep: this.currentStep,
                                                      steps: steps,
                                                      // onStepTapped: (step) {
                                                      //   UpdateSteps(step);
                                                      // },
                                                      controlsBuilder: (BuildContext context,
                                                          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                                                        return (currentStep==2)?
                                                        // Padding(
                                                        //   padding: EdgeInsets.only(left: 15, right: 15),
                                                        //   child: Row(
                                                        //     mainAxisSize: MainAxisSize.max,
                                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                                        //     children: <Widget>[
                                                        //       Expanded(
                                                        //         child: getThemeButton("Back", themeGreen, context, true, () {
                                                        //           setState(() {
                                                        //             currentStep--;
                                                        //             UpdateSteps(currentStep);
                                                        //           });
                                                        //         }),
                                                        //       ),
                                                        //       SizedBox(
                                                        //         width: 5,
                                                        //       ),
                                                        //       Expanded(
                                                        //         child: getThemeButton(
                                                        //             "Confirm", themeGreen, context, true, () {
                                                        //             isLoading = true;
                                                        //             setState(() {
                                                        //
                                                        //             });
                                                        //             isAgree=true;
                                                        //           if(!isAgree){
                                                        //             showToast("Please agree to vbet Terms & Conditions");
                                                        //             return;
                                                        //           }
                                                        //            else{
                                                        //             var username=mapData["username"];
                                                        //             var first_name=mapData["first_name"];
                                                        //             var last_name=mapData["last_name"];
                                                        //             var email=mapData["email"];
                                                        //             var password=mapData["password"];
                                                        //             var currency_name=mapData["currency_name"];
                                                        //             var birth_date=mapData["birth_date"];
                                                        //             var zip_code=mapData["zip_code"];
                                                        //             var city=mapData["city"];
                                                        //             var address=mapData["address"];
                                                        //             var mobile_phone=mapData["Phone_code"]+mapData["mobile_phone"];
                                                        //             var max_daily_bet_amount=mapData["max_daily_bet_amount"];
                                                        //             var max_weekly_bet_amount=mapData["max_weekly_bet_amount"];
                                                        //             var max_monthly_bet_amount=mapData["max_monthly_bet_amount"];
                                                        //             var country=mapData["country"];
                                                        //             var country_code=mapData["country_code"];
                                                        //             var Phone_code=mapData["Phone_code"];
                                                        //             var gender=mapData["gender"];
                                                        //             var promoCode=mapData["promo_code"];
                                                        //
                                                        //             RegisterUserRequest userInfo = RegisterUserRequest(
                                                        //                 int.parse(partnerId),
                                                        //                 username,
                                                        //                 password,
                                                        //                 first_name,
                                                        //                 last_name,
                                                        //                 gender,
                                                        //                 birth_date,
                                                        //                 "eng",
                                                        //                 max_monthly_bet_amount,
                                                        //                 max_daily_bet_amount,
                                                        //                 address,
                                                        //                 city,
                                                        //                 country_code,
                                                        //                 email,
                                                        //                 currency_name,
                                                        //                 promoCode,
                                                        //                 zip_code,
                                                        //                 mobile_phone,
                                                        //                 null,
                                                        //                 null,
                                                        //                 null
                                                        //             );
                                                        //             RegisterRequest registerRequest = RegisterRequest(cmdRegisterUser+cmdId, cmdRegisterUser,
                                                        //                 RegisterRequestParams(userInfo));
                                                        //             String json = jsonEncode(registerRequest);
                                                        //             print(json);
                                                        //             isLoading = true;
                                                        //             setState(() {
                                                        //
                                                        //             });
                                                        //            channel.sink.add(json);
                                                        //           }
                                                        //         }),
                                                        //       )
                                                        //     ],
                                                        //   ),
                                                        // )
                                                        Container()
                                                            :Container();}),

                                                ),
                                              )



                                            ])))
                                  ]),
                                  RecaptchaV2(
//                          apiKey: "6LeCwZYUAAAAAJo8IVvGX9dH65Rw89vxaxErCeou",
//                          apiSecret: "6LeCwZYUAAAAAKGahIjwfOARevvRETgvwhPMKCs_",
                                    apiKey: "6LfwfzgaAAAAAN3wAkm8a9iMlKQ7NUlOxdblq245",   //SITE key
                                    apiSecret: "6LfwfzgaAAAAAPSq2g4As4n9n1pxgJmGnqZnjASD",//SECRET key
                                    controller: recaptchaV2Controller,
                                    onVerifiedError: (err){
                                      print(err);
                                    },
                                    onVerifiedSuccessfully: (success) {
                                      setState(() {
                                        if (success) {
                                          showToast("You've been verified successfully.");
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomeView()
                                              )
                                          );
                                        } else {
                                          showToast("Failed to verify.");
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),




                          )
                  )
                  );


                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String selectedCountryCode = "";

  Widget _buildCountrySelection() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width - 32,
      child: Stack(
        children: [
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: txtCountry,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: themeWhite,
              prefixIcon: Container(
                child: getFlag(selectedCountryCode),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Container(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Select Country",
              hintStyle: GoogleFonts.openSans(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeBlue, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: themeBlue, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeBlue, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              color: Colors.transparent,
            ),
            onTap: () {
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  print('Select country: ${country.displayName}');
                  txtCountry.text = country.name;
                  selectedCountryCode = country.countryCode;
                  setState(() {});
//                  Utils.countryCodeToEmoji(country.countryCode)
                },
              );
            },
          )
        ],
      ),
    );
  }

  String _dropDownCurrency = "";

  Widget _buildCurrencySelection(String value) {
    String selectionName = "Currency";

    if (listCurrency != null && listCurrency.length != 0) {
    } else {
      listCurrency.add("No Data");
    }

    if (value == "") {
      _dropDownCurrency = listCurrency[0];
      txtCurrency.text = _dropDownCurrency;
    }

    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width - 32,
      child: FormField(
        builder: (FormFieldState state) {
          return DropdownButtonHideUnderline(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeWhite,
//                      suffixIcon: Container(
//                        child: Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
//                      ),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    hintText: "Select Country",
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: themeBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  isEmpty: _dropDownCurrency == null,
                  child: new DropdownButton<String>(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    value: _dropDownCurrency,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _dropDownCurrency = newValue;
                        txtCurrency.text = _dropDownCurrency;
                      });
                    },
                    items: listCurrency.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  getFlag(String flag) {
    if (flag != "") {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              countryCodeToEmoji(flag),
              style: const TextStyle(fontSize: 30),
            )
          ],
        ),
      );
    } else {
      return Icon(Icons.flag, color: themeBlue);
    }
  }

  void getCurrencyList() {
    CurrencyRequest currencyRequest = CurrencyRequest(
        rid: cmdGetCurrency + cmdId,
        command: cmdGetCurrency,
        params: CurrencyRequestParams(
            source: "partner.config",
            what: CurrencyRequestWhat(partner: List<String>())));

    String json = jsonEncode(currencyRequest);
    channel.sink.add(json);
  }
}
