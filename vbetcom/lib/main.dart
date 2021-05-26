import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/Models/Session/SessionResponse.dart';
import 'package:vbetcom/Views/HomeView.dart';
import 'package:vbetcom/Views/StartUp/StartUpView.dart';

void main() {
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  loadPreference() async {
    HttpOverrides.global = new MyHttpOverrides();
    AppPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    loadPreference();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'vbet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeMaterialBlue,
        textSelectionColor: Colors.deepPurpleAccent.withOpacity(0.3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'vbet',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


//  Stream broadcastStream;
//  IOWebSocketChannel channel;

  @override
  void dispose() {
    super.dispose();
//    stopSession(channel);
//    channel.sink.close();
  }


  @override
  void initState() {
//    channel = IOWebSocketChannel.connect(websocketUrl);
//    broadcastStream = startSession(channel);
    super.initState();

    Timer(Duration(seconds: 3), (){
//      stopSession(channel);

      bool isLogin = AppPreferences.getBool(keyIsUserLogin);
      if(isLogin != null && isLogin == true){
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context) => HomeView()//MyAppSocket()//StartUpView()
          )
        );
      }else{
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context) => StartUpView()//MyAppSocket()//StartUpView()
          )
        );
      }


    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StreamBuilder(
//      stream: broadcastStream,
      builder: (context, snapshot){

//        if(snapshot.hasError){
//          showToast(snapshot.error.toString());
//        }
//        if(snapshot.hasData){
//          SessionResponse response = SessionResponse.fromJson(jsonDecode(snapshot.data));
//
//          if(response.data == null){
//            showToast(response.msg);
//          }
//
//        }

        return Container(
            decoration: BoxDecoration(
              color: themeBlue
//        image: DecorationImage(
//          image: AssetImage("assets/images/gradient.png"),
//          fit: BoxFit.cover
//        ),

//            gradient: LinearGradient(
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//                colors: <Color>[
//                  themeBlue,
//                  themePink,
//                ])

            ),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.width / 2.5,
                child: Image.asset('assets/images/vbet-gif.gif'),
              ),
            )
        );
      },
    );
  }

}
