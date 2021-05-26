import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/UIComponents/Widgets.dart';
import 'package:vbetcom/Views/HomeView.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';
import 'package:vbetcom/Views/Register/RegisterView.dart';
import 'package:vbetcom/Views/SignUp/SignUpView.dart';
import 'package:video_player/video_player.dart';

class StartUpView extends StatefulWidget {

  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/video/background-video.mp4'
    )..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });

  }
  
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//        color: Colors.black,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size?.width ?? 0,
                  height: _controller.value.size?.height ?? 0,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 110),
                      child: Text("Welcome To", style: GoogleFonts.openSans(fontSize: 20, fontWeight: semiBold, color: themeWhite),),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 21),
                        height: 70,//MediaQuery.of(context).size.width / 2.3,
                        width: 184,//MediaQuery.of(context).size.width / 2.3,
                        child: Image.asset('assets/images/vbet_logo.png'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                child: startupWidget(),
                height: MediaQuery.of(context).size.height - 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  startupWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              getThemeButton("Sign In", themeGreen, context, true, (){
                
//                Navigator.push(context, MaterialPageRoute(
//                  builder: (context)=>HomeView()
//                ));

                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>LoginView()
                ));

              }),

              Container(
                margin: EdgeInsets.only(bottom: 16, top: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: GestureDetector(
                        child: Text(
                          "Don’t have an account? Sign up?",
                          style: GoogleFonts.openSans(
                            color: themeWhite,
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>SignUpView()
                          ));

                        },
                      ),
                    )
                  ],
                ),
//                child: getThemeButton("Join", themeWhite, context, false, (){
//                  Navigator.push(context, MaterialPageRoute(
//                      builder: (context)=>RegisterView()
//                  ));
//                }),
              ),

            ],
          ),
        ),
      ],
    );
  }

  

}
