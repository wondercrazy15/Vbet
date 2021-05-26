import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';

class SignUpView2 extends StatefulWidget {
  int currentStep;
  final Function function;
  SignUpView2({this.currentStep,Key key,this.function}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpView2State(currentStep: currentStep);
  }

}

class SignUpView2State extends State<SignUpView2> {
  int currentStep;
  SignUpView2State({this.currentStep});
  static TextEditingController txtGender = TextEditingController();
  static TextEditingController dateController = TextEditingController();
  static TextEditingController txtPostcode = TextEditingController();
  static TextEditingController txtCity = TextEditingController();
  static TextEditingController txtAddress = TextEditingController();
  static TextEditingController txtMobileNo = TextEditingController();
  static TextEditingController txtDailyDeposit = TextEditingController();
  static TextEditingController txtWeeklyDeposit = TextEditingController();
  static TextEditingController txtMonthlyDeposit = TextEditingController();
  static TextEditingController txtCountry = TextEditingController();
  static TextEditingController txtCountryCode = TextEditingController();
  static TextEditingController txtselectedPhoneCode = TextEditingController();
  //String selectedCountryCode="";
  //String selectedPhoneCode="";
  Widget _buildCountrySelection() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width - 32,
      child: Stack(
        children: [
          TextFormField(
            style: GoogleFonts.openSans(color: Colors.grey,fontSize: 16),
            textCapitalization: TextCapitalization.sentences,
            controller: txtCountry,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: themeBlueLight,
              prefixIcon: Container(
                child: getFlag(txtCountryCode.text),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Container(
                  child: Icon(null),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
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
                  txtCountryCode.text = country.countryCode;
                  txtselectedPhoneCode.text="+"+country.phoneCode;
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

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1996),
      firstDate: DateTime(1996),
      lastDate: currentDate,
      helpText: 'Select Date of Birth',
      // Can be used as title
      cancelText: 'Not valid',
      confirmText: 'Birth date',
    );

    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
  }
  bool isAgree = false;
  bool isPasswordObscure = true;
  bool IsCaptchaVerified=false;
  bool status = false;
  ButtonStyle btnStyle= TextButton.styleFrom(
    backgroundColor: themeMaterialGreen,
  );
  ButtonStyle male= null;
  ButtonStyle female=null;
  @override
  void initState() {
    super.initState();
    if(txtGender.text==""){
      male= btnStyle;
      female=null;
      txtGender.text="M";
    }
    else{
      if(txtGender.text=="M"){
        male= btnStyle;
        female=null;
      }else{
        female= btnStyle;
        male=null;
      };
    }
    (txtDailyDeposit.text=="")?
    txtDailyDeposit.text="200":txtDailyDeposit.text;
    (txtWeeklyDeposit.text=="")?
    txtWeeklyDeposit.text="1000":txtWeeklyDeposit.text;
    (txtMonthlyDeposit.text=="")?
    txtMonthlyDeposit.text="5000":txtMonthlyDeposit.text;
    txtCountry.text=(txtCountry.text=="")?"United Kingdom":txtCountry.text;
    txtCountryCode.text = (txtCountryCode.text=="")?"GB":txtCountryCode.text;
    txtselectedPhoneCode.text=(txtselectedPhoneCode.text=="")?"+44":txtselectedPhoneCode.text;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FocusNode focusNode = FocusNode();
    return Column(
      children: [
        SizedBox(height: 60,),
        getSwitcher(context, "Gender", "Male", "Female", male, female,
              () {
            setState(() {
              setState(() {
                if(male==null){
                  male=btnStyle;
                  txtGender.text="M";
                  female=null;
                }
              });
            });
          },
              () {
            setState(() {
              if(female==null){
                female=btnStyle;
                txtGender.text="F";
                male=null;
              }
            });
          },
        ),
        SizedBox(height: 12.0,),
        Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 24),
        width: MediaQuery.of(context).size.width - 32,
          child:  TextField(
            style: Theme.of(context).textTheme.bodyText1,
            readOnly: true,
            controller: dateController,
            decoration: InputDecoration(
                filled: true,
                fillColor: themeWhite,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: themeWhite, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeWhite, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeWhite, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintStyle: GoogleFonts.openSans(color: Colors.grey),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                //prefixIcon: Icon(Icons.date_range_sharp),
                prefixIconConstraints: BoxConstraints(
                  minHeight: 35,
                  minWidth: 35,
                ),
                suffixIcon: Icon(Icons.date_range_sharp,
                    color: Colors.grey),
                hintText: 'Date of Birth'),
            onTap: () async {
              _selectDate(context);
              //dateController.text = currentDate.toString().substring(0,10);
            },
          ),
        ),
        _buildCountrySelection(),
        // getThemeTextFieldNonClickable(context, null, "United Kingdom", TextInputType.text, false, focusNode, TextInputAction.next,
        //     Padding(padding: EdgeInsets.only(left: 15,top: 10,right: 10,bottom: 10),
        //       child: Image.asset("assets/images/unitedkingdom.png"),
        //     ),
        //     null),
        getThemeTextField(context, txtPostcode, "Postcode*", TextInputType.number, false, focusNode, TextInputAction.next,null),
        getThemeTextField(context, txtCity, "City*", TextInputType.text, false, focusNode, TextInputAction.next,null),
        getThemeTextField(context, txtAddress, "Address", TextInputType.streetAddress, false, focusNode, TextInputAction.next,null),
        getThemeTextField(context, txtMobileNo, " 7911 123456", TextInputType.numberWithOptions(signed: true), false, focusNode,
            TextInputAction.next,Padding(padding: EdgeInsets.only(left: 15,top: 12,right: 1), child: Text(txtselectedPhoneCode.text,style: GoogleFonts.openSans(color: Colors.grey,fontSize: 16),)),),
        SizedBox(width: 20.0,),
        Padding(padding: EdgeInsets.only(left: 15,bottom: 5),child: Align(
          alignment: Alignment.topLeft, // Align however you like (i.e .centerRight, centerLeft)
          child: Text("Max Daily Deposit",style: GoogleFonts.openSans(color: Colors.white,fontSize: 16.0,),textAlign: TextAlign.start,),
        ),),
        getThemeTextField(context, txtDailyDeposit, "1000", TextInputType.number, false, focusNode, TextInputAction.next,null),
        SizedBox(width: 20.0,),
        Padding(padding: EdgeInsets.only(left: 15,bottom: 5),child: Align(
          alignment: Alignment.topLeft, // Align however you like (i.e .centerRight, centerLeft)
          child: Text("Max Weekly Deposit",style: GoogleFonts.openSans(color: Colors.white,fontSize: 16.0,),textAlign: TextAlign.start,),
        ),),
        getThemeTextField(context, txtWeeklyDeposit, "1000", TextInputType.number, false, focusNode, TextInputAction.next,null),
        SizedBox(width: 20.0,),
        Padding(padding: EdgeInsets.only(left: 15,bottom: 5),child: Align(
          alignment: Alignment.topLeft, // Align however you like (i.e .centerRight, centerLeft)
          child: Text("Max Monthly Deposit",style: GoogleFonts.openSans(color: Colors.white,fontSize: 16.0,),textAlign: TextAlign.start,),
        ),),
        getThemeTextField(context, txtMonthlyDeposit, "1000", TextInputType.number, false, focusNode, TextInputAction.done,null),
        SizedBox(width: 25.0,),
        Padding(padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),child: Align(
          alignment: Alignment.topCenter, // Align however you like (i.e .centerRight, centerLeft)
          child: Text("Safer Gambling message. Set limits on your gambling. For support, contact the National Gambling "
              "Helpline on 0808 8020 133 or visit www.begambleaware.org",style: GoogleFonts.openSans(color: Colors.white,fontSize: 14.0,),
            textAlign: TextAlign.center,),
        ),),

        Padding(padding: EdgeInsets.only(left: 15,right: 15),child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: getThemeButton("Back", themeGreen, context, true, (){
                      setState(() {
                        currentStep--;
                        widget.function(currentStep);
                      });
                    }),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:getThemeButton("Next", themeGreen, context, true, (){
                      String Postcode = txtPostcode.text;
                      String City = txtCity.text;
                      String Mono=txtMobileNo.text;
                      String dateBirth=dateController.text;
                      String address=txtAddress.text;

                      if(Postcode == null || Postcode.length == 0){
                        showToast("Please enter postcode");
                        return;
                      }
                      else if(City == null || City.length == 0){
                        showToast("Please enter city");
                        return;
                      }
                      else if(address == null || address.length == 0){
                        showToast("Please enter address");
                        return;
                      }
                      else if(Mono == null || Mono.length == 0){
                        showToast("Please enter mobile number");
                        return;
                      }
                      // else if(Mono.length !=10){
                      //   showToast("Mobile number must be 10 characters");
                      //   return;
                      // }

                      else{
                        setState(() {
                          currentStep++;
                          widget.function(currentStep);
                        });
                      }

                    }),
                  )
                ],
              )),
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
      ],
    );
  }

}