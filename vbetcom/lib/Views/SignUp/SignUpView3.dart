import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/Models/Register/RegisterRequest.dart';
import 'package:vbetcom/Models/Register/RegisterUserRequest.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';
import 'package:web_socket_channel/io.dart';

class SignUpView3 extends StatefulWidget {
  int currentStep;
  final Function function;
  Stream broadcastStream;
  HashMap<String,String> mapInfo = HashMap<String,String>();
  IOWebSocketChannel channel;
  bool isLoading;
  SignUpView3(this.mapInfo,{this.currentStep, Key key, this.function,this.channel,this.broadcastStream,this.isLoading}) : super(key: key);

  // var mapInfo = HashMap<String,String>();
  //
  // SignUpView3(this.mapInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpView3State(channel:channel,currentStep: currentStep,broadcastStream:broadcastStream,isLoading:isLoading);
  }
}

class SignUpView3State extends State<SignUpView3> {
  int currentStep;
  Stream broadcastStream;
  IOWebSocketChannel channel;
  SignUpView3State({this.currentStep,this.channel,this.broadcastStream,this.isLoading});
  ButtonStyle btnStyle = TextButton.styleFrom(
    backgroundColor: themeMaterialGreen,
  );
  ButtonStyle InternalMessegeYes = null;
  ButtonStyle InternalMessegeNo = null;

  ButtonStyle NotificationYes = null;
  ButtonStyle NotificationNo = null;

  ButtonStyle EmailYes = null;
  ButtonStyle EmailNo = null;

  ButtonStyle SMSYes = null;
  ButtonStyle SMSNo = null;

  ButtonStyle CallYes = null;
  ButtonStyle CallNo = null;

  static TextEditingController txtPromoCode = TextEditingController();
  static TextEditingController txtIsAgree = TextEditingController();
  static TextEditingController txtIsMessege = TextEditingController();
  static TextEditingController txtIsNotification = TextEditingController();
  static TextEditingController txtIsEmail = TextEditingController();
  static TextEditingController txtIsSMS = TextEditingController();
  static TextEditingController txtIsCall = TextEditingController();
  static TextEditingController txtIsLoading = TextEditingController();
  static TextEditingController txtloader = TextEditingController();

  bool isAgree = false;
  bool isMessege=true;
  bool isNotification=true;
  bool isEmail=true;
  bool isSMS=true;
  bool isCall=true;
  bool isLoading;
  @override
  void initState() {
    super.initState();
    InternalMessegeYes = btnStyle;
    NotificationYes=btnStyle;
    EmailYes=btnStyle;
    SMSYes=btnStyle;
    CallYes=btnStyle;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          getSwitcher(context, "Internal Messege", "Yes", "No", InternalMessegeYes, InternalMessegeNo,
            () {
              setState(() {
                if (InternalMessegeYes == null) {
                  InternalMessegeYes = btnStyle;
                  InternalMessegeNo = null;
                  isMessege=true;

                }
              });
            },
            () {
              setState(() {
                if (InternalMessegeNo == null) {
                  InternalMessegeNo = btnStyle;
                  InternalMessegeYes = null;
                  isMessege=false;
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          getSwitcher(context, "Push Notification", "Yes", "No", NotificationYes, NotificationNo,
                () {
              setState(() {
                if (NotificationYes == null) {
                  NotificationYes = btnStyle;
                  NotificationNo = null;
                  isNotification=true;
                }
              });
            },
                () {
              setState(() {
                if (NotificationNo == null) {
                  NotificationNo = btnStyle;
                  NotificationYes = null;
                  isNotification=false;
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          getSwitcher(context, "Email", "Yes", "No", EmailYes, EmailNo,
                () {
              setState(() {
                if (EmailYes == null) {
                  EmailYes = btnStyle;
                  EmailNo = null;
                  isEmail=true;
                }
              });
            },
                () {
              setState(() {
                if (EmailNo == null) {
                  EmailNo = btnStyle;
                  EmailYes = null;
                  isEmail=false;
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          getSwitcher(context, "SMS", "Yes", "No", SMSYes, SMSNo,
                () {
              setState(() {
                if (SMSYes == null) {
                  SMSYes = btnStyle;
                  SMSNo = null;
                  isSMS=true;
                }
              });
            },
                () {
              setState(() {
                if (SMSNo == null) {
                  SMSNo = btnStyle;
                  SMSYes = null;
                  isSMS=false;
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          getSwitcher(context, "Phone Call", "Yes", "No", CallYes, CallNo,
                () {
              setState(() {
                if (CallYes == null) {
                  CallYes = btnStyle;
                  CallNo = null;
                  isCall=true;
                }
              });
            },
                () {
              setState(() {
                if (CallNo == null) {
                  CallNo = btnStyle;
                  CallYes = null;
                  isCall=false;
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          getThemeTextField(context, txtPromoCode, "Promo Code", TextInputType.text, false, focusNode, TextInputAction.done,null),

          Container(
            margin: EdgeInsets.only(left: 0, bottom: 54),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white,),
                  child: Checkbox(
                    value: isAgree,
                    activeColor: themeWhite,
                    checkColor: themeBlue,
                    onChanged: (value){
                      isAgree = value;
                      txtIsAgree.text=value.toString();
                      setState(() {

                      });
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: Text(
                      "I agree with all terms and conditions.",
                      style: GoogleFonts.openSans(
                          color: themeWhite,
                          fontSize: 15
                      ),
                    ),
                  ),
                  onTap: (){
                    showToast("Terms & Conditions");
//                                          Navigator.pop(context, "Pop");
//                                      stopSession(channel);
//                                      Navigator.push(context, MaterialPageRoute(
//                                        builder: (context)=>TermsAndConditionView()
//                                      ));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: getThemeButton("Back", themeGreen, context, true, () {
                    setState(() {
                      currentStep--;
                      widget.function(currentStep);
                    });
                  }),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: getThemeButton(
                      "Confirm", themeGreen, context, true, () {
                    if(!isAgree){
                    showToast("Please agree to vbet Terms & Conditions");
                    return;
                    }else
                      {

                      var username=widget.mapInfo["username"];
                      var first_name=widget.mapInfo["first_name"];
                      var last_name=widget.mapInfo["last_name"];
                      var email=widget.mapInfo["email"];
                      var password=widget.mapInfo["password"];
                      var currency_name=widget.mapInfo["currency_name"];
                      var birth_date=widget.mapInfo["birth_date"];
                      var zip_code=widget.mapInfo["zip_code"];
                      var city=widget.mapInfo["city"];
                      var address=widget.mapInfo["address"];
                      var mobile_phone=widget.mapInfo["Phone_code"]+widget.mapInfo["mobile_phone"];
                      var max_daily_bet_amount=widget.mapInfo["max_daily_bet_amount"];
                      var max_weekly_bet_amount=widget.mapInfo["max_weekly_bet_amount"];
                      var max_monthly_bet_amount=widget.mapInfo["max_monthly_bet_amount"];
                      var country=widget.mapInfo["country"];
                      var country_code=widget.mapInfo["country_code"];
                      var Phone_code=widget.mapInfo["Phone_code"];
                      var gender=widget.mapInfo["gender"];
                      var promoCode=txtPromoCode.text;
                      txtloader.text="true";
                      DateFormat format = DateFormat('yyyy-MM-dd');
                      print(format.parse(birth_date));

                      RegisterUserRequest userInfo = RegisterUserRequest(
                          username,
                          password,
                          first_name,
                          last_name,
                          gender,
                          birth_date,
                          "eng",
                          max_monthly_bet_amount,
                          max_daily_bet_amount,
                          address,
                          city,
                          country_code,
                          email,
                          currency_name,
                          promoCode,
                          zip_code,
                          mobile_phone,
                          (isEmail)?isEmail:null,
                        (isSMS)?isSMS:null,
                          null
                      );
                      RegisterRequest registerRequest = RegisterRequest(cmdRegisterUser+cmdId, cmdRegisterUser,
                          RegisterRequestParams(userInfo));
                      String json = jsonEncode(registerRequest);
                      print(json);
                      channel.sink.add(json);
                      setState(() {
                        isLoading = true;
                        currentStep=2;
                        widget.function(currentStep);
                      });
                    }

                  }),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30, top: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: GestureDetector(
                    child: Text(
                      "Already have an account? Sign in",
                      style: GoogleFonts.openSans(color: themeWhite),
                    ),
                    onTap: () async {
                      var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginView()));
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}
