import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'myapp.dart';
import 'package:toast/toast.dart';
import 'package:banko_mac/models/spor.dart';
import 'package:http/http.dart' as http;

class LiveScore extends StatefulWidget {

  List<Match> liste;
  LiveScore(this.liste);

  _LiveScoreState createState() => _LiveScoreState();
}



class _LiveScoreState extends State<LiveScore> {

  List<Match> liste;
  SharedPreferences prefs;
  bool isLock = true;
  String tur;
  Icon openLock = Icon(FontAwesomeIcons.lockOpen,color: Colors.white);
  Icon lock = Icon(FontAwesomeIcons.lock,color: Colors.white54);

  Future<bool>_decrementCounter() async {
    prefs = await SharedPreferences.getInstance();
    if((money = (prefs.getInt('credi') ?? 0)) >= 3){
      money = (prefs.getInt('credi') ?? 0) - 3;
      await prefs.setInt('credi', money);
      setState(() {     
      });
      return true;
    }else{
      return false;
    }}

  void getCredi()async{
      prefs = await SharedPreferences.getInstance();
      money = (prefs.getInt('credi') ?? 0);
      setState(() { 
      });
    }

  Future<List<Match>> getLive() async {
    var response = await http.get(liveUrl);
    if(response.statusCode == 200){
      var data = (json.decode(response.body) as List).map((data) => Match.fromJsonLive(data)).toList();
      return data;
    }else{
      throw "Hata : ${response.statusCode}";
    }  
  }

    @override
  void initState() {
    super.initState();
    this.liste = widget.liste;
    ads.videoListener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.rewarded:
          {
             setState(() {
            });  
            Toast.show(AppLocalizations.of(context).translate('rewarded'), context,duration: 3,backgroundColor: Colors.green,gravity:1,textColor: Colors.white);      
          }
          break;         
        default:
          print("There's a 'new' RewardedVideoAdEvent?!");
      }
    }; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF212121),
        appBar: GradientAppBar(actions: <Widget>[
          Row(children: <Widget>[
            Icon(Icons.attach_money),
            Text(money.toString()),
            SizedBox(width: 10,),
            InkWell(
              onTap: () {  
                ads.showVideoAd(state: this);
                Toast.show(AppLocalizations.of(context).translate('load_video'), context, duration: 3,backgroundColor: Colors.pink,textColor: Colors.white,gravity: 1);
              },
              child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white
              ),
              child: Row(children: <Widget>[SizedBox(width: 2,),Text(AppLocalizations.of(context).translate('coin_button'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)])),),
          ],),
          SizedBox(width: 5,),
          //Icon(Icons.more_vert),
         ],title: Text(AppLocalizations.of(context).translate('app_name')),
         gradient: LinearGradient(begin:Alignment.topLeft, end: Alignment.bottomRight,
         colors: [Color(0xFF0485DBF),Color(0xFF3285FC)]
           ),),

           body:  Column(
             children: <Widget>[
               
               Flexible(child:liveMatch()),
               AdmobBanner(
               adUnitId: bannerUnitId,
                adSize: AdmobBannerSize.FULL_BANNER,
               ),

             ],
           )
    );
  }
  Widget liveMatch(){
    return FutureBuilder<List<Match>>(
                 future: getLive(),
                 builder: (BuildContext context, AsyncSnapshot<List<Match>> snapshot){
                   if(snapshot.hasData){
                     return Column(
                       children: <Widget>[
                         SizedBox(height: 4,),
                         Expanded(
                           child:
                           ListView.builder(
                             itemCount: snapshot.data.length,
                             itemBuilder: (context,index){
                               return  Padding(
                                 padding: const EdgeInsets.only(top: 4.0,left: 8,right: 8,bottom: 6),
                                 child: Container(
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                       color:Color(0xFF2B3445)
                                   ),
                                   child: Column(
                                     mainAxisSize: MainAxisSize.max,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       // 1.Kısım // Saat - Ülke
                                       Padding(
                                         padding: EdgeInsets.only(left: 4),
                                         child:  Row(
                                           mainAxisSize: MainAxisSize.max,
                                           children: <Widget>[
                                             snapshot.data[index].ulke == "Türkiye"
                                                 ? Image.network("https://www.countryflags.io/TR/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "İskoçya"
                                                 ? Image.asset("assets/country/scotland.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Rusya"
                                                 ? Image.network("https://www.countryflags.io/RU/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Çek Cumhuriyeti"
                                                 ? Image.network("https://www.countryflags.io/CZ/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Norveç"
                                                 ? Image.network("https://www.countryflags.io/NO/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Hollanda"
                                                 ? Image.network("https://www.countryflags.io/NL/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Meksika"
                                                 ? Image.network("https://www.countryflags.io/MX/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "İtalya"
                                                 ? Image.network("https://www.countryflags.io/IT/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "İzlanda"
                                                 ? Image.network("https://www.countryflags.io/IE/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Yunanistan"
                                                 ? Image.network("https://www.countryflags.io/GR/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Almanya"
                                                 ? Image.network("https://www.countryflags.io/DE/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Fransa"
                                                 ? Image.network("https://www.countryflags.io/FR/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Finlandiya"
                                                 ? Image.network("https://www.countryflags.io/FI/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "İngiltere"
                                                 ? Image.network("https://www.countryflags.io/GB/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Danimarka"
                                                 ? Image.network("https://www.countryflags.io/DK/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Çin"
                                                 ? Image.network("https://www.countryflags.io/CN/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Brezilya"
                                                 ? Image.network("https://www.countryflags.io/BR/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Avusturya"
                                                 ? Image.network("https://www.countryflags.io/AT/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Avustralya"
                                                 ? Image.network("https://www.countryflags.io/AU/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Arjantin"
                                                 ? Image.network("https://www.countryflags.io/AR/shiny/64.png",height: 30,width: 35,)
                                                 : snapshot.data[index].ulke == "Uefa"
                                                 ? Padding(padding: EdgeInsets.only(top: 3),child: Image.asset("assets/country/uefa.png",height: 30,width: 35,),)
                                                 : snapshot.data[index].ulke == "Champions"
                                                 ? Padding(padding: EdgeInsets.only(top: 3),child: Image.asset("assets/country/champions.png",height: 30,width: 35,),)
                                                 : snapshot.data[index].ulke == "İspanya"
                                                 ? Image.network("https://www.countryflags.io/ES/shiny/64.png",height: 30,width: 35,)
                                                 : Image.asset("assets/country/genel.png",height: 30,width: 35,),

                                             Padding(
                                               padding: EdgeInsets.only(left:20),
                                               child: Text("-   "+snapshot.data[index].takim1,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),),
                                              Expanded(
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                               children: <Widget>[
                                                 Padding(
                                                   padding: const EdgeInsets.only(top: 5,right:8.0),
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                     ),
                                                     child: liste[index].tur == "Ucretsiz"
                                                         ? openLock
                                                         : InkWell(
                                                       child: liste[index].tur == "Ucretsiz"
                                                           ? openLock
                                                           : lock,
                                                       onTap: (){
                                                         _decrementCounter().then((isTrue){
                                                           print("Degeri :"+liste[index].tur);
                                                           if(isTrue){
                                                             setState(() {
                                                               liste[index].tur = "Ucretsiz";
                                                               Toast.show(AppLocalizations.of(context).translate('open_lock') + " : " + "$money", context, duration: Toast.LENGTH_MEDIUM, gravity:  Toast.CENTER,backgroundColor: Colors.green,textColor: Colors.white);
                                                             });

                                                           }else{
                                                             Toast.show(AppLocalizations.of(context).translate('error_lock'), context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER,backgroundColor: Color(0xFFB00020),textColor: Colors.white);
                                                           }
                                                         });
                                                       },
                                                     ),



                                                   ),
                                                 )
                                               ],),
                                           ) ,
                                           ],),
                                       ),

                                       //2.Kısım // Tarih
                                       Padding(
                                         padding: EdgeInsets.only(top: 6,left: 4),
                                         child: Row(children: <Widget>[
                                               snapshot.data[index].spor == "Futbol"
                                               ? Image.asset("assets/spor/futbol.png",height: 35,width: 35,)
                                               : Image.asset("assets/spor/basketball.png",height: 25,width: 35,),
                                           Padding(
                                             padding: EdgeInsets.only(left:22),
                                             child: Text("-   "+snapshot.data[index].takim2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                                                                                       Expanded(
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                               children: <Widget>[
                                                 Padding(
                                                   padding: const EdgeInsets.only(top: 5,right:8.0),
                                                   child: Container(
                                                       decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.all(Radius.circular(10)),
                                                       ),
                                                       child: Padding(padding: EdgeInsets.all(2),
                                                         child: Text("%"+snapshot.data[index].guven,style: TextStyle(color:Colors.amberAccent,fontWeight: FontWeight.bold),),
                                                       )
                                                   ),
                                                 )
                                               ],),
                                           ),


                                         ],),),

                                       //3.Kısım // Mac Kodu - Spor
                                       Padding(
                                         padding: EdgeInsets.only(top: 6,left: 4,bottom: 4),
                                         child: Row(children: <Widget>[         
                                           Padding(
                                               padding: EdgeInsets.only(left:50),
                                               child: Row(children: <Widget>[
                                                 Icon(
                                                     snapshot.data[index].durum == "Beklemede"
                                                         ? Icons.timer
                                                         : snapshot.data[index].durum == "Lose"
                                                         ? FontAwesomeIcons.times
                                                         : FontAwesomeIcons.solidCheckCircle
                                                     ,color: snapshot.data[index].durum == "Beklemede"
                                                     ? Colors.orangeAccent
                                                     : snapshot.data[index].durum == "Lose"
                                                     ? Colors.redAccent
                                                     : Colors.greenAccent
                                                 ),
                                                 SizedBox(width: 3,),
                                                 liste[index].tur == "Ucretsiz"
                                                     ? Text(" "+liste[index].tahmin,style: TextStyle(fontWeight: FontWeight.bold,
                                                     color: snapshot.data[index].durum == "Beklemede"
                                                         ? Colors.orangeAccent
                                                         : snapshot.data[index].durum == "Lose"
                                                         ? Colors.redAccent
                                                         : Colors.greenAccent)
                                                 )
                                                     :Text(AppLocalizations.of(context).translate('vip_match')+ " ",style: TextStyle(color:Colors.orangeAccent,fontWeight: FontWeight.bold)),
                                               ],)
                                           ),
                                         ],),),
                                     ],
                                   ),
                                 ),
                               );
                             },
                           ),
                         ),
                         /*AdmobBanner(
                           adUnitId: bannerUnitId,
                           adSize: AdmobBannerSize.FULL_BANNER,
                         ),*/
                       ],
                     );

                   }else{
                     return Center(child:  CircularProgressIndicator(

                     ),);
                   }
                 },
               );
  }
}