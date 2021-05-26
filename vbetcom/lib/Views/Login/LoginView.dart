import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/Models/All/CommonParser.dart';
import 'package:vbetcom/Models/All/ValidateCaptchaResponse.dart';
import 'package:vbetcom/Models/Login/LoginRequest.dart';
import 'package:vbetcom/Models/Login/LoginResponse.dart';
import 'package:vbetcom/Models/Session/SessionResponse.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/Home/DashboardView.dart';
import 'package:vbetcom/Views/HomeView.dart';
import 'package:vbetcom/Views/Register/RegisterView.dart';
import 'package:vbetcom/Views/ResetPassword/ResetPasswordView.dart';
import 'package:vbetcom/Views/SignUp/SignUpView.dart';
import 'package:vbetcom/Views/StartUp/StartUpView.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:crypto/crypto.dart';

class LoginView extends StatefulWidget {

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  bool isPasswordObscure = true;
  bool isLoading = true;

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



  @override
  void dispose() {
    super.dispose();
    stopSession(channel);
    channel.sink.close();
    if(!recaptchaV2Controller.isDisposed){
      recaptchaV2Controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Scaffold(
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

              //Loader stuff
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

//              CommonParser parser = CommonParser.fromJson(jsonDecode(snapshot.data));

              if(snapshot.hasData){
                CommonParser parser = CommonParser.fromJson(jsonDecode(snapshot.data));
                if(parser.code == 5 && parser.msg == "Invalid session"){
                  //Invalid Session
                  channel = IOWebSocketChannel.connect(websocketUrl);
                  broadcastStream = channel.stream.asBroadcastStream();
                  startSession(channel);
                }
                if(parser.rid == cmdLoginUser+cmdId){
                  if(parser.code == 0){
                    print("login");
                    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(snapshot.data));

                    AppPreferences.setString(keyUserLoggedInData, snapshot.data);
                    AppPreferences.setBool(keyIsUserLogin, true);

                    new Future.delayed(new Duration(seconds: 0), () {
                      showToast("Login successful");
                      stopSession(channel);

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (context) => HomeView()
                          )
                      );

                    });

                  }else{
                    showToast(parser.msg);
                  }
                }else if(parser.rid == cmdRequestSession+cmdId){
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
              }
              print("Data: " + snapshot.data.toString());

              return Container(
                color: themeBlue,
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Column(
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
                                        height: 49,
                                        child: Image.asset('assets/images/vbet_logo.png'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 34, top: 58),
                                      child: Text("Sign In", style: GoogleFonts.openSans(fontSize: 24, fontWeight: semiBold, color: themeWhite),),
                                    ),
                                    getThemeTextField(context, txtEmail, "Enter your email or username", TextInputType.emailAddress, false, focusNode, TextInputAction.next,null),
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width - 32,
                                      child: TextFormField(
                                        controller: txtPassword,
                                        obscureText: isPasswordObscure,
                                        onFieldSubmitted: (value){
                                          focusNode.unfocus();
                                        },
                                        textInputAction: TextInputAction.done,
                                        style: GoogleFonts.openSans(),
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
//                                            child: isPasswordObscure?Icon(Icons.visibility, color: themeBlue, size: 22):Icon(Icons.visibility_off, color: themeBlue,size: 22),
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

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 50,
                                          margin: EdgeInsets.only(top: 10, right: 25),
                                          child: GestureDetector(
                                            child: Text(
                                              "Forgot Password?",
                                              style: GoogleFonts.openSans(
                                                  color: themeWhite
                                              ),
                                            ),
                                            onTap: (){
//                                        stopSession(channel);
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context)=>ResetPasswordView()
                                              ));
//                                          channel = IOWebSocketChannel.connect(websocketUrl);
//                                          broadcastStream = channel.stream.asBroadcastStream();

//                                        startSession(channel);
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[

                                  getThemeButton("Sign In", themeGreen, context, true, (){

//                                    recaptchaV2Controller.show();

                                    String email = txtEmail.text;
                                    String password = txtPassword.text;

                                    if(email == null || email.length == 0){
                                      showToast("Please enter email");
                                      return;
                                    }
//                              else if(!isValidEmail(email)){
//                                showToast("Please enter valid email");
//                                return;
//                              }
                                    else if(password == null || password.length == 0){
                                      showToast("Please enter password");
                                      return;
                                    }else{

                                    }

                                    LoginRequestParams params = LoginRequestParams(email, password);
                                    LoginRequest loginRequest = LoginRequest(cmdLoginUser+cmdId, cmdLoginUser, params);
                                    String json = jsonEncode(loginRequest);

                                    isLoading = true;
                                    setState(() {

                                    });
                                    channel.sink.add(json);

                                  }),

                                  Container(
                                    margin: EdgeInsets.only(bottom: 32, top: 13),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: GestureDetector(
                                            child: Text(
                                              "Don’t have an account? Sign up?",
                                              style: GoogleFonts.openSans(
                                                  color: themeWhite
                                              ),
                                            ),
                                            onTap: () async {
                                              stopSession(channel);

//                                          var result = await Navigator.push(context, MaterialPageRoute(
//                                            builder: (context)=>HomeView()
//                                          ));

                                              var result = await Navigator.push(context, MaterialPageRoute(
                                                  builder: (context)=>SignUpView()
                                              ));

                                              channel = IOWebSocketChannel.connect(websocketUrl);
                                              broadcastStream = channel.stream.asBroadcastStream();
                                              startSession(channel);
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


}
