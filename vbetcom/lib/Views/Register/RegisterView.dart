import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vbetcom/Models/Session/SessionRequest.dart';
import 'package:vbetcom/Models/Session/SessionResponse.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/Home/DashboardView.dart';
import 'package:vbetcom/Views/HomeView.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';
import 'package:vbetcom/Views/StartUp/StartUpView.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class RegisterView extends StatefulWidget {

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  Stream broadcastStream;
  IOWebSocketChannel channel;

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
  }

  TextEditingController txtUserName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtCountry = TextEditingController();
  TextEditingController txtCurrency = TextEditingController();
  TextEditingController txtPromoCode = TextEditingController();

  bool isAgree = false;
  bool isPasswordObscure = true;
  bool IsCaptchaVerified=false;

  @override
  Widget build(BuildContext context) {
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
                builder: (context, snapshot){
                  //Loading Stuff
                  if (!snapshot.hasData) {
                    if (snapshot.data != null && snapshot.data.length == 0) {

                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = false;
                        setState(() {

                        });
                      });

                    }
                    else{
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = true;
                        setState(() {

                        });
                      });
                      return Container();
                    }
                  }else{
                    if(isLoading){
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = false;
                        setState(() {

                        });
                      });
                    }

                  }
                  print("Connection State: " + snapshot.connectionState.toString());


                  if(snapshot.hasError){
                    print("Error: " + snapshot.error.toString());
                  }
                  CommonParser parser = CommonParser.fromJson(jsonDecode(snapshot.data));
//              if(parser.code == 5){
//                stopSession(channel);
//                  channel = IOWebSocketChannel.connect(websocketUrl);
//                  broadcastStream = channel.stream.asBroadcastStream();

//                startSession(channel);
//              }
                  print("Data: " + snapshot.data.toString());

                  if(snapshot.hasData){
                    CommonParser parser = CommonParser.fromJson(jsonDecode(snapshot.data));




                    if(parser.rid == cmdGetCurrency+cmdId){
                      if(parser.code == 0){
                        CurrencyResponse currencyResponse = CurrencyResponse.fromJson(jsonDecode(snapshot.data));
                        List<String> currencyList;
                        try{
                          currencyList = currencyResponse.data.data.partner.one.supportedCurrencies;
                        }catch(exc){
                          currencyList = List<String>();
                        }
                        listCurrency = List<String>();
                        for(int i=0; i < currencyList.length; i++){
                          listCurrency.add(currencyList[i]);
                        }
                      }else{
                        showToast(parser.msg);
                      }

                    }else if(parser.rid == cmdRegisterUser+cmdId){
                      if(parser.code == 0){
                        RegisterResponse registerResponse = RegisterResponse.fromJson(jsonDecode(snapshot.data));
                        if(registerResponse.data.result.toString().toLowerCase() == "ok"){
                          AppPreferences.setString(keyUserRegistrationData, snapshot.data);
                          AppPreferences.setBool(keyIsUserLogin, true);

                          new Future.delayed(new Duration(milliseconds: 0), () {
                            showToast("Register successful");
                            stopSession(channel);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (context) => HomeView()
                                )
                            );
                          });

                        }else{
                          if(isLoading){
                            showToast(registerResponse.data.resultText);
                            isLoading = false;
                          }
                        }

                      }else{
                        if(isLoading){
                          showToast(parser.msg);
                          isLoading = false;
                        }
                      }
                    }else if(parser.rid == cmdRequestSession+cmdId){
                      getCurrencyList();
                      SessionResponse requestSessionResponse = SessionResponse.fromJson(jsonDecode(snapshot.data));
                      String json = md5Hashing(requestSessionResponse.data.sid);
                      new Future.delayed(new Duration(milliseconds: 0), () {
                        isLoading = true;
                        setState(() {
                        });
                      });
                      channel.sink.add(json);
                     }else if(parser.rid == cmdValidateCaptcha+cmdId){
                      try{
                        ValidateCaptchaResponse validateCaptchaResponse = ValidateCaptchaResponse.fromJson(jsonDecode(snapshot.data));
                        if(validateCaptchaResponse != null && validateCaptchaResponse.data != null && validateCaptchaResponse.data.result == false){
                          showToast("Something went wrong, Try again later");
                        }
                      }catch(ex){
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
                        height: MediaQuery.of(context).size.height<940 ? 940 : MediaQuery.of(context).size.height,
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 80),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 128,
                                        height: 48,
                                        child: Image.asset('assets/images/vbet_logo.png'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 59, bottom: 32),
                                      child: Text("Sign Up", style: GoogleFonts.openSans(fontSize: 24, fontWeight: semiBold, color: themeWhite),),
                                    ),

                                    getThemeTextField(context, txtUserName, "Username", TextInputType.text, false, focusNode, TextInputAction.next,null),
                                    getThemeTextField(context, txtEmail, "Email", TextInputType.emailAddress, false, focusNode, TextInputAction.next,null),
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(bottom: 24),
                                      width: MediaQuery.of(context).size.width - 32,
                                      child: TextFormField(
                                        controller: txtPassword,
                                        obscureText: isPasswordObscure,
                                        onFieldSubmitted: (value){
                                          focusNode.unfocus();
                                        },
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: (){
                                                isPasswordObscure = !isPasswordObscure;
                                                focusNode.unfocus();

                                                setState(() {

                                                });

                                              },
                                              icon: Padding(
                                                padding: EdgeInsets.only(right: 4),
                                                child: isPasswordObscure?Image.asset("assets/images/show.png"):Image.asset("assets/images/hide.png"),
//                                            child: isPasswordObscure?Icon(Icons.visibility, color: themeBlue, size: 22,):Icon(Icons.visibility_off, color: themeBlue,size: 22),
                                              )
                                          ),
                                          filled: true,
                                          fillColor: themeWhite,
                                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                          hintText: "Password",
                                          hintStyle: GoogleFonts.openSans(color: Colors.grey),
                                          focusedBorder:OutlineInputBorder(
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
                                    ),

                                    _buildCountrySelection(),

                                    _buildCurrencySelection(""),

                                    getThemeTextField(context, txtPromoCode, "Promo Code", TextInputType.text, false, focusNode, TextInputAction.done,null),

                                    Container(
                                      margin: EdgeInsets.only(left: 18, bottom: 54),
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


                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[

                                  getThemeButton("Sign Up", themeGreen, context, true, (){
                                    String username = txtUserName.text;
                                    String email = txtEmail.text;
                                    String password = txtPassword.text;
                                    String country = txtCountry.text;
                                    String currency = txtCurrency.text;
                                    String promoCode = txtPromoCode.text;

                                    if(username == null || username.length == 0){
                                      showToast("Please enter username");
                                      return;
                                    }else if(email == null || email.length == 0){
                                      showToast("Please enter email");
                                      return;
                                    }else if(!isValidEmail(email)){
                                      showToast("Please enter valid email");
                                      return;
                                    }else if(password == null || password.length == 0){
                                      showToast("Please enter password");
                                      return;
                                    }else if(password.length < 8 || password.length > 12){
                                      showToast("Password must be 8-12 characters long");
                                      return;
                                    }else if(country == null || country.length == 0 || selectedCountryCode == ""){
                                      showToast("Please select country");
                                      return;
                                    }else if(currency == null || currency.length == 0){
                                      showToast("Please select currency");
                                      return;
                                    }else if(currency.toLowerCase() == "no data"){
                                      showToast("No currency loaded, Try later.");
                                      return;
                                    }else if(!isAgree){
                                      showToast("Please agree to vbet Terms & Conditions");
                                      return;
                                    }else{
                                      RegisterRequestUserInfo userInfo = RegisterRequestUserInfo(
                                          username,
                                          password,
                                          selectedCountryCode,
                                          email,
                                          currency,
                                          promoCode,
                                          int.parse(partnerId),
                                          "3600",
                                          "eng",
                                          isAgree
                                      );


                                      // RegisterRequest registerRequest = RegisterRequest(cmdRegisterUser+cmdId, cmdRegisterUser,
                                      //     RegisterRequestParams(userInfo));
                                      // String json = jsonEncode(registerRequest);
                                      // print(json);
                                       isLoading = true;
                                      setState(() {

                                      });
//                                  channel.sink.add(jsonEncode(LogOutRequest(cmdLogout)));
                                      channel.sink.add(json);

                                    }

                                  }),

                                  Container(
                                    margin: EdgeInsets.only(bottom: 16, top: 13),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: GestureDetector(
                                            child: Text(
                                              "Already have an account? Sign in",
                                              style: GoogleFonts.openSans(
                                                  color: themeWhite
                                              ),
                                            ),
                                            onTap: () async {
                                              stopSession(channel);
                                              var result = await Navigator.push(context, MaterialPageRoute(
                                                  builder: (context)=>LoginView()
                                              ));

                                              channel = IOWebSocketChannel.connect(websocketUrl);
                                              broadcastStream = channel.stream.asBroadcastStream();

                                              startSession(channel);
                                              setState(() {

                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Select Country",
              hintStyle: GoogleFonts.openSans(color: Colors.grey),
              focusedBorder:OutlineInputBorder(
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
            child: Container(color: Colors.transparent,),
            onTap: (){
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  print('Select country: ${country.displayName}');
                  txtCountry.text = country.name;
                  selectedCountryCode = country.countryCode;
                  setState(() {

                  });
//                  Utils.countryCodeToEmoji(country.countryCode)
                },
              );
            },
          )

        ],
      ),
    );

  }

  getFlag(String flag) {
    if(flag != ""){
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(countryCodeToEmoji(flag), style: const TextStyle(fontSize: 30),)
          ],
        ),
      );
    }else{
      return Icon(Icons.flag, color: themeBlue);
    }

  }

  String _dropDownCurrency = "";
  Widget _buildCurrencySelection(String value) {

    String selectionName = "Currency";

    if(listCurrency != null && listCurrency.length != 0){

    }else{
      listCurrency.add("No Data");
    }

    if(value == ""){
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
                    focusedBorder:OutlineInputBorder(
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
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
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



  void getCurrencyList() {

    CurrencyRequest currencyRequest = CurrencyRequest(
        rid: cmdGetCurrency+cmdId,
        command: cmdGetCurrency,
        params: CurrencyRequestParams(source: "partner.config", what: CurrencyRequestWhat(partner: List<String>()))
    );

    String json = jsonEncode(currencyRequest);
    channel.sink.add(json);

  }

}

