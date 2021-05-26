//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:vbetcom/Common/Global.dart';
//
//String selectedUrl = 'https://flutter.io';
//
//final Set<JavascriptChannel> jsChannels = [
//  JavascriptChannel(
//      name: 'Print',
//      onMessageReceived: (JavascriptMessage message) {
//        print(message.message);
//      }),
//].toSet();
//
//class DashboardView extends StatefulWidget {
//  @override
//  _DashboardViewState createState() => _DashboardViewState();
//}
//
//class _DashboardViewState extends State<DashboardView> {
//
//  final flutterWebViewPlugin = FlutterWebviewPlugin();
//  bool isLoading = true;
//  // On destroy stream
//  StreamSubscription _onDestroy;
//
//  // On urlChanged stream
//  StreamSubscription<String> _onUrlChanged;
//
//  // On urlChanged stream
//  StreamSubscription<WebViewStateChanged> _onStateChanged;
//
//  StreamSubscription<WebViewHttpError> _onHttpError;
//
//  StreamSubscription<double> _onProgressChanged;
//
//  StreamSubscription<double> _onScrollYChanged;
//
//  StreamSubscription<double> _onScrollXChanged;
//
//
//
//  final _urlCtrl = TextEditingController(text: selectedUrl);
//
//  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');
//
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//  final _history = [];
//
//  @override
//  void initState() {
//    super.initState();
//
//    flutterWebViewPlugin.close();
//
//    _urlCtrl.addListener(() {
//      selectedUrl = _urlCtrl.text;
//    });
//
//    // Add a listener to on destroy WebView, so you can make came actions.
//    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
//      if (mounted) {
//        // Actions like show a info toast.
//        print('Webview Destroyed');
//      }
//    });
//
//    // Add a listener to on url changed
//    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
//      if (mounted) {
//        setState(() {
//          _history.add('onUrlChanged: $url');
//          print("Url changed");
//        });
//      }
//    });
//
//    _onProgressChanged =
//        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
//          if (mounted) {
//            setState(() {
//              _history.add('onProgressChanged: $progress');
//            });
//          }
//        });
//
//    _onScrollYChanged =
//        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
//          if (mounted) {
//            setState(() {
//              _history.add('Scroll in Y Direction: $y');
//            });
//          }
//        });
//
//    _onScrollXChanged =
//        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
//          if (mounted) {
//            setState(() {
//              _history.add('Scroll in X Direction: $x');
//            });
//          }
//        });
//
//    _onStateChanged =
//        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
//          if (mounted) {
//            if(state.type == WebViewState.startLoad){
//              isLoading = true;
//            }else if(state.type == WebViewState.finishLoad){
//              isLoading = false;
//            }
//            setState(() {
//              _history.add('onStateChanged: ${state.type} ${state.url}');
//              print('onStateChanged: ${state.type} ${state.url}');
//            });
//          }
//        });
//
//    _onHttpError =
//        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
//          if (mounted) {
//            setState(() {
//              _history.add('onHttpError: ${error.code} ${error.url}');
//              print('onHttpError: ${error.code} ${error.url}');
//            });
//          }
//        });
//  }
//
//  @override
//  void dispose() {
//    // Every listener should be canceled, the same should be done with this stream.
//    _onDestroy.cancel();
//    _onUrlChanged.cancel();
//    _onStateChanged.cancel();
//    _onHttpError.cancel();
//    _onProgressChanged.cancel();
//    _onScrollXChanged.cancel();
//    _onScrollYChanged.cancel();
//
//    flutterWebViewPlugin.dispose();
//
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: themeBlue,
//      child: SafeArea(
//        child: Stack(
//          children: [
//            Theme(
//              data: ThemeData(
//                backgroundColor: themeBlue
//              ),
//              child: WebviewScaffold(
//                url: "https://vbetcom-updated.springbuilder.site/",
//                javascriptChannels: jsChannels,
//                mediaPlaybackRequiresUserGesture: false,
//                withZoom: true,
//                withLocalStorage: true,
//                hidden: true,
//                initialChild: Container(
//                  color: themeBlue,
//                  child: SpinKitChasingDots(//SpinKitWanderingCubes
//                    color: themePink,
//                    size: 50.0,
//                  ),
//                ),
//
////              bottomNavigationBar: BottomAppBar(
////                child: Row(
////                  children: <Widget>[
////                    IconButton(
////                      icon: const Icon(Icons.arrow_back_ios),
////                      onPressed: () {
////                        flutterWebViewPlugin.goBack();
////                      },
////                    ),
////                    IconButton(
////                      icon: const Icon(Icons.arrow_forward_ios),
////                      onPressed: () {
////                        flutterWebViewPlugin.goForward();
////                      },
////                    ),
////                    IconButton(
////                      icon: const Icon(Icons.autorenew),
////                      onPressed: () {
////                        flutterWebViewPlugin.reload();
////                      },
////                    ),
////                  ],
////                ),
////              ),
//              ),
//            ),
//            ModalProgressHUD(
//              inAsyncCall: false,
//              color: themeBlue,
//              progressIndicator: SpinKitChasingDots(//SpinKitWanderingCubes
//                color: themePink,
//                size: 50.0,
//              ),
//              opacity: 1,
//              child: Container(),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
