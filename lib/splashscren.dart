import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'myapp.dart';
import 'package:banko_mac/models/spor.dart';




class SplashApp extends StatefulWidget {
  List <Match> list;
  SplashApp(List<Match> data){
    list = data;
  }

  @override
  _SplashAppState createState() => new _SplashAppState();
}


class _SplashAppState extends State<SplashApp> {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      title: Text(AppLocalizations.of(context).translate('app_name'),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
      image: Image.asset("assets/app.png",height: 230,width: 170,),
      navigateAfterSeconds:  MyApp(widget.list),
      gradientBackground: LinearGradient(begin:Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.deepPurpleAccent,Colors.deepPurple]),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}