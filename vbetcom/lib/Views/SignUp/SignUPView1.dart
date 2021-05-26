import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/UIComponents/stepper.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';

class SignUpView1 extends StatefulWidget {

  int currentStep;
  final Function function;
  List<String> listCurrency;
  SignUpView1({this.currentStep,Key key,this.function,this.listCurrency}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpView1State(currentStep: currentStep,listCurrency:listCurrency);
  }
}

class SignUpView1State extends State<SignUpView1> {
  int currentStep;
  List<String> listCurrency;
  SignUpView1State({this.currentStep,this.listCurrency});
  static TextEditingController txtUserName = TextEditingController();
  static TextEditingController txtFirstName = TextEditingController();
  static TextEditingController txtLastName = TextEditingController();
  static TextEditingController txtEmail = TextEditingController();
  static TextEditingController txtPassword = TextEditingController();
  static TextEditingController txtCountry = TextEditingController();
  static TextEditingController txtCurrency = TextEditingController();

  bool isAgree = false;
  bool isPasswordObscure = true;
  bool IsCaptchaVerified=false;

  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FocusNode focusNode = FocusNode();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 32, bottom: 32),
            child: Text("Sign Up", style: GoogleFonts.openSans(fontSize: 24, fontWeight: semiBold, color: themeWhite),),
          ),

          getThemeTextField(context, txtUserName, "Username", TextInputType.text, false, focusNode, TextInputAction.next,null),
          getThemeTextField(context, txtEmail, "Email", TextInputType.emailAddress, false, focusNode, TextInputAction.next,null),
          getThemeTextField(context, txtFirstName, "First Name", TextInputType.text, false, focusNode, TextInputAction.next,null),
          getThemeTextField(context, txtLastName, "Last Name", TextInputType.text, false, focusNode, TextInputAction.next,null),
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
              textInputAction: TextInputAction.done,
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
          _buildCurrencySelection(""),
          Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getThemeButton("Next", themeGreen, context, true, (){
                      String username = txtUserName.text;
                      String firstname = txtFirstName.text;
                      String lastname = txtLastName.text;
                      String email = txtEmail.text;
                      String password = txtPassword.text;
                      String currency = txtCurrency.text;
                      if(username == null || username.length == 0){
                        showToast("Please enter username");
                        return;
                      }else if(firstname == null || firstname.length == 0){
                        showToast("Please enter firstname");
                        return;
                      }
                      else if(lastname == null || lastname.length == 0){
                        showToast("Please enter lastname");
                        return;
                      }
                      else if(email == null || email.length == 0){
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
                      }else if(currency == null || currency.length == 0){
                        showToast("Please select currency");
                        return;
                      }else if(currency.toLowerCase() == "no data"){
                        showToast("No currency loaded, Try later.");
                        return;}
                      else{
                        setState(() {
                          currentStep++;
                          widget.function(currentStep);
                        });
                      }
                    }),
                  ],
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
                            style: GoogleFonts.openSans(
                                color: themeWhite
                            ),
                          ),
                          onTap: () async {
                            var result = await Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>LoginView()
                            ));

                          },
                        ),
                      )
                    ],
                  ),
                ),
          SizedBox(height: 30,),
        ],),
    );
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
      margin: EdgeInsets.only(bottom: 80),
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
                    fillColor: themeBlueLight,
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
                    icon: Icon(null),
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
                        child: Text(value,style: TextStyle(color: Colors.grey),),
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
}