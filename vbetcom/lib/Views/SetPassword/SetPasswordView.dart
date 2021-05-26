import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/ChangePassword/ChangePasswordView.dart';

class SetPasswordView extends StatefulWidget {
  @override
  _SetPasswordViewState createState() => _SetPasswordViewState();
}

class _SetPasswordViewState extends State<SetPasswordView> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

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
                      margin: EdgeInsets.only(top: 80,),
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
                            child: Text("Set Password", style: GoogleFonts.openSans(fontSize: 24, fontWeight: semiBold, color: themeWhite),),
                          ),

                          getThemeTextField(context, txtPassword, "New Password", TextInputType.text, true, focusNode, TextInputAction.next,null),
                          getThemeTextField(context, txtConfirmPassword, "Confirm New Password", TextInputType.text, true, focusNode, TextInputAction.done,null),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        getThemeButton("Confirm", themeGreen, context, true, (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>ChangePasswordView()
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
