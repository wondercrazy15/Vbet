import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController txtOldPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmNewPassword = TextEditingController();

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
                            margin: EdgeInsets.only(top: 58, bottom: 38),
                            child: Text("Change Password", style: GoogleFonts.openSans(fontSize: 24, fontWeight: semiBold, color: themeWhite),),
                          ),

                          getThemeTextField(context, txtOldPassword, "Current Password", TextInputType.text, true, focusNode, TextInputAction.next,null),
                          getThemeTextField(context, txtNewPassword, "New Password", TextInputType.text, true, focusNode, TextInputAction.next,null),
                          getThemeTextField(context, txtConfirmNewPassword, "Confirm New Password", TextInputType.text, true, focusNode, TextInputAction.done,null),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[

                        getThemeButton("Confirm", themeGreen, context, true, (){

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
