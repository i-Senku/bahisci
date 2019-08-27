import 'package:flutter/material.dart';

class LanguageApp extends StatefulWidget {
  LanguageApp({Key key}) : super(key: key);

  _LanguageAppState createState() => _LanguageAppState();
}

class _LanguageAppState extends State<LanguageApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: Color(0xFF212121),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
          ),
          Center(
            child: Text("Select Langueage",style:TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.deepPurple,
              onPressed: () => print("English"),
              child: Row(children: <Widget>[
                Image.asset("assets/country/usa.png",height: 50,width: 50,),
                Text("  English",style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
              ],),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.green,
              onPressed: () => print("Türkçe"),
              child: Row(children: <Widget>[
                Image.asset("assets/country/turkey.png",height: 50,width: 50,),
                Text("  Türkçe",style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
              ],),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.brown,
              onPressed: () => print("Germany"),
              child: Row(children: <Widget>[
                Image.asset("assets/country/germany.png",height: 50,width: 50,),
                Text("  Germany",style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
              ],),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.orange,
              onPressed: () => print("Germany"),
              child: Row(children: <Widget>[
                Image.asset("assets/country/italy.png",height: 50,width: 50,),
                Text("  İtaly",style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
              ],),
            ),
          ),
        ],
      ),
    ),
    );
  }
}