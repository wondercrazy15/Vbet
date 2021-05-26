import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  String redirectUrl = "https://www.vbet.co.uk/"; //https://embed.vbet.com/    //"https://vbetcom-updated.springbuilder.site/";
//  WebViewController controllerGlobal;
  bool isLoading = true;

//  final cookieManager = WebviewCookieManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("Home", style: new GoogleFonts.openSans(color: Colors.white),),
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                  begin: Alignment.topCenter,
//                  end: Alignment.bottomCenter,
//                  colors: <Color>[
//                    themeBlue,
//                    themePink
//                  ])
//          ),
//        ),
//      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: themeBlue,
        progressIndicator: getLoader(),
        opacity: 1,
        child: Container(
          color: themeBlue,
          child: SafeArea(
            child: WebView(
              initialUrl: redirectUrl,
              javascriptMode: JavascriptMode.unrestricted,

              onPageStarted: (String url) async {
                try{
                  isLoading = true;
                  print("Started");
//                final String cookieValue = 'some-cookie-value';
//                final String domain = redirectUrl;
//                final String cookieName = 'some_cookie_name';
//
//                await cookieManager.setCookies([
//                  Cookie(cookieName, cookieValue)
//                    ..domain = domain
//                    ..expires = DateTime.now().add(Duration(days: 10))
//                    ..httpOnly = false
//                ]);
                  setState(() {

                  });
                }catch(ex){
                  print(ex);
                }
              },
              onPageFinished: (String url) async {

                try{

                  isLoading = false;
                  print("Finished");
//                final gotCookies = await cookieManager.getCookies(redirectUrl);
//                print("//Dinal Cookies");
//                for (var item in gotCookies) {
//                  print(item);
//                }
//                print("//Dinal Cookies");
                  setState(() {

                  });

                }catch(ex){
                  print(ex);
                }

              },
            ),
          ),
        ),
      ),
    );
  }

}
