 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vbetcom/Common/Global.dart';


Widget getThemeButton(String title, Color borderColor, BuildContext context, bool isFilled, method){
  return Container(
    height: 48,
    width: MediaQuery.of(context).size.width - 32,
    margin: EdgeInsets.only(top: 8, bottom: 8),
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: borderColor, width: 2)),
      color: isFilled?borderColor:Colors.transparent,
      textColor: Colors.white,
      onPressed: method,
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 16.0,
          fontWeight: semiBold
        ),
      ),
    ),
  );
}

Widget getThemeTextField(BuildContext context, TextEditingController controller, String hint, TextInputType inputType,
    bool isSecure, FocusNode currentNode, TextInputAction event,Widget prefix){
  bool isCapitalizeFirst = false;
  if(hint.toLowerCase().contains("email") || hint.toLowerCase().contains("password") || hint.toLowerCase().contains("first name")||hint.toLowerCase().contains("last name")||hint.toLowerCase().contains("username")){
    isCapitalizeFirst = false;
  }else{
    isCapitalizeFirst = true;
  }
  return Container(
    height: 50,
    margin: EdgeInsets.only(bottom: 24),
    width: MediaQuery.of(context).size.width - 32,
    child: TextFormField(
      textCapitalization: isCapitalizeFirst ? TextCapitalization.sentences : TextCapitalization.none,
      controller: controller,
      keyboardType: inputType,
      obscureText: isSecure,
      style: GoogleFonts.openSans(),
      onFieldSubmitted: (value){
        event==TextInputAction.done?currentNode.unfocus():currentNode.nextFocus();
      },
      textInputAction: event,
      decoration: InputDecoration(
        prefixIcon: prefix,
        filled: true,
        fillColor: themeWhite,
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: hint,
//        labelText: label,
//        labelStyle: GoogleFonts.openSans(color: themeBlue),
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
  );
}

Widget getSwitcher(BuildContext context,String Messege,String fistBtnText,String secondBtnText,ButtonStyle first,ButtonStyle second,firstmethod,secondmethod){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start, //change here don't //worked
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: 15.0,),
      Text(Messege,style: GoogleFonts.openSans(color: Colors.white,fontSize: 16.0,),textAlign: TextAlign.center,),Spacer(),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          color: Colors.transparent,
        ),
        height: 45,width: 150,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(child: TextButton(
                  onPressed: firstmethod,
                  child: Text(fistBtnText,style: TextStyle(color: Colors.white,fontSize: 14),),
                  style: first),margin: EdgeInsets.only(left: 5,right: 0),),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Container(child: TextButton(
                  onPressed:secondmethod,
                  child: Text(secondBtnText,style: TextStyle(color: Colors.white,fontSize: 14),),
                  style: second),margin: EdgeInsets.only(left: 0,right: 5),),
            ),
          ],
        ),
      ),
      SizedBox(width: 20.0,),
    ],);
}

 Widget getThemeTextFieldNonClickable(BuildContext context, TextEditingController controller, String hint, TextInputType inputType, bool isSecure,
     FocusNode currentNode, TextInputAction event,Widget preIcon,Widget suffIcon){

   return Container(
     height: 50,
     margin: EdgeInsets.only(bottom: 24),
     width: MediaQuery.of(context).size.width - 32,
     child: TextFormField(
       controller: controller,
       keyboardType: inputType,
       obscureText: isSecure,
       style: GoogleFonts.openSans(),
       onFieldSubmitted: (value){
         event==TextInputAction.done?currentNode.unfocus():currentNode.nextFocus();
       },
       textInputAction: event,
         enabled: false,
         decoration: InputDecoration(

           prefixIcon: preIcon,
           suffixIcon: suffIcon,
           filled: true,
           hintText:hint,
           fillColor: themeBlueLight,
           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
//        labelText: label,
//        labelStyle: GoogleFonts.openSans(color: themeBlue),
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
         )
     ),
   );
 }


