import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/Register/RegisterView.dart';
import 'package:vbetcom/Views/SetPassword/SetPasswordView.dart';

class ResetPasswordView extends StatefulWidget {
  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();


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
        child: Container(
          color: themeBlue,
          child: SingleChildScrollView(
            child: Container(
              color: themeBlue,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 24),
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
                              height: 49,
                              child: Image.asset('assets/images/vbet_logo.png'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 38, top: 58),
                            child: Text("Reset Password", style: GoogleFonts.openSans(fontSize: 24, fontWeight: semiBold, color: themeWhite),),
                          ),
                          getThemeTextField(context, txtEmail, "Email Address", TextInputType.emailAddress, false, focusNode, TextInputAction.next,null),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[

                        getThemeButton("Send Reset Link", themeGreen, context, true, (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>SetPasswordView()
                          ));
                        }),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




}
