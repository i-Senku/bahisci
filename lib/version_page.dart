import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class VersionPage extends StatefulWidget {
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> with SingleTickerProviderStateMixin{

  int sayi = 5;
  //AnimationController _controller;

   _goUpdate() async {
  final url = 'https://play.google.com/store/apps/details?id=net.mypinky.banko_mac';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Error : $url';
  }
}

  @override
  void initState() {
    super.initState();
    
    // *********** Animasyon Kısmı ****************

    /*_controller = AnimationController(vsync: this,duration: Duration(seconds: 3),lowerBound: 10,upperBound: 50);
    _controller.forward();

    _controller.addListener((){
      print(_controller.value);
      print(_controller.status);
    });

    _controller.addStatusListener((status){
      if(status == AnimationStatus.completed){
        _controller.reverse();
      }else if(status == AnimationStatus.dismissed){
        _controller.forward();
      }
    });*/

   /* Timer.periodic(Duration(seconds: 1), (t){
      if(sayi == 0){
        t.cancel();
        _goUpdate();
      }else{
        setState(() {
       sayi -=1; 
      });
      }
    });*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
       body: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
         Center(
         child: AnimatedContainer(
          child: Icon(Icons.info,size: 100 ,color: Colors.cyan,),
          duration: Duration(seconds: 3),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
       ),
       ),
       SizedBox(height: 20,),
         Text("You are using the older version.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
         Text("Please Update Application.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
         
        SizedBox(height: 30,),
        InkWell(
          onTap: _goUpdate,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Colors.blueAccent,Colors.indigo])
            ),
            width: 200,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Icon(Icons.system_update,color: Colors.white,),
              SizedBox(width: 5,),
              Text("Update !",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
              ],
            ),
        ),
        )
       

       ],)
    );
  }
}