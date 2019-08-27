import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:banko_mac/live.dart';
import 'package:banko_mac/models/spor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:onesignal/onesignal.dart';
import 'app_localizations.dart';

final String appId = 'ca-app-pub-8706234629359911~3261472488';
final String bannerUnitId = 'ca-app-pub-8706234629359911/5976099885';
final String videoUnitId = 'ca-app-pub-8706234629359911/1974997897';

String url = "https://mypinky.net/bankomac/maclar";
String liveUrl = "https://mypinky.net/bankomac/canli";
Ads ads;
int money;

class MyApp extends StatefulWidget {
  
  List<Match> liste;
  MyApp(List<Match> list){
    liste = list;
  }

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  List<Color> butonRenkleri = [Colors.grey,Colors.grey];
  List<double> opacity = [0.1,0.1];

  String filtre;

  List<Match> liste,liveList;
  List<Match> futbolList;
  SharedPreferences prefs;
  bool isLock = true;
  String tur;
  Icon openLock = Icon(FontAwesomeIcons.lockOpen,color: Colors.white);
  Icon lock = Icon(FontAwesomeIcons.lock,color: Colors.white54);

  void _incrementCounter() async {
    prefs = await SharedPreferences.getInstance();
    money = (prefs.getInt('credi') ?? 0) + 1;
    await prefs.setInt('credi', money);
    setState(() {     
    });
    }
    
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

  Future<List<Match>> getData() async {
    var response = await http.get(url);
    if(response.statusCode == 200){
      var data = (json.decode(response.body) as List).map((data) => Match.fromJson(data)).toList();
      return data;
    }else{
      throw "Hata : ${response.statusCode}";
    }  
  }
    
  Future<List<Match>> getFutbol() async {
    var response = await http.get(url);
    if(response.statusCode == 200){      
     var data = json.decode(response.body);
     List liste = List();

     for(var i =0; i<(data as List).toList().length; i++){
       if(data[i]['spor'] == "Futbol"){
         liste.add(data[i]);
       }
     }
    var sonuc = liste.map((data) => Match.fromJson(data)).toList();
    return sonuc;
    }else{
      throw "Hata : ${response.statusCode}";
    }  
  }

  Future<List<Match>> getBasketbol() async {
    var response = await http.get(url);
    if(response.statusCode == 200){      
     var data = json.decode(response.body);
     List liste = List();

     for(var i =0; i<(data as List).toList().length; i++){
       if(data[i]['spor'] == "Basketbol"){
         liste.add(data[i]);
       }
     }
    var sonuc = liste.map((data) => Match.fromJson(data)).toList();
    return sonuc;
    }else{
      throw "Hata : ${response.statusCode}";
    }  
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    OneSignal.shared.init("f04fd284-3a0d-4365-aae0-aeaaaa9a04b2");

    filtre = "All";
    liste = widget.liste;
    ads = Ads(appId);
    ads.setVideoAd(
      adUnitId: videoUnitId,
      childDirected: true,
      testDevices: null,
    );

    ads.videoListener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.rewarded:
          {
             setState(() {
            _incrementCounter(); 
            });  
            Toast.show(AppLocalizations.of(context).translate('rewarded'), context,duration: 3,backgroundColor: Colors.green,gravity:1,textColor: Colors.white);      
          }
          break;         
        default:
          print("There's a 'new' RewardedVideoAdEvent?!");
      }
    };   
    getCredi();

  }
  @override
  void dispose() {
    ads.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
       child: Scaffold(
         backgroundColor: Color(0xFF212121),
         drawer: Drawer(
           child: Container(
             color: Color(0xFF212121),
             child: Column(
               mainAxisSize: MainAxisSize.max,
               children: <Widget>[
                 DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin:Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Color(0xFF0485DBF),Color(0xFF3285FC)]
                    )
              ),
              child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/app.png",width: 100,height: 80,),
                  Padding(
                padding: const EdgeInsets.only(bottom:2.0),
                child: Text(AppLocalizations.of(context).translate('app_name'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500)),
              ),
                ],
              ),)
               ),
               SizedBox(height: 10,),
               Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(30)),
                   //gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Color(0xFF0485DBF),Color(0xFF3285FC)])
                 ),
                 child: ListTile(leading: Icon(Icons.home,color: Colors.white,),title: Text(AppLocalizations.of(context).translate('home'),style: TextStyle(color: Colors.white),)),
               ),
               Divider(color: Colors.white54,),
               InkWell(onTap: () => launch("mailto:<ercngp@gmail.com>"),child: ListTile(leading: Icon(Icons.contact_mail,color: Colors.white,),title: Text(AppLocalizations.of(context).translate('contact'),style: TextStyle(color: Colors.white)))),
               Divider(color: Colors.white54,),
               InkWell(onTap: () => launch("https://play.google.com/store/apps/details?id=net.mypinky.banko_mac"),child: ListTile(leading: Icon(Icons.star,color: Colors.white,),title: Text(AppLocalizations.of(context).translate('rate_app'),style: TextStyle(color: Colors.white))),),
               Divider(color: Colors.white54,),
               InkWell(onTap: () => launch("https://mypinky.net/provicy.txt"),child: ListTile(leading: Icon(Icons.info,color: Colors.white,),title: Text(AppLocalizations.of(context).translate('privacy'),style: TextStyle(color: Colors.white))),),
               Divider(color: Colors.white54,),
               Expanded(child: Align(
                 alignment: Alignment.bottomCenter,
                 child: Row(
                         children: <Widget>[
                           Expanded(child: Padding(
                             padding: const EdgeInsets.only(left:3,right: 2,bottom: 4),
                             child: Container(
                             decoration: BoxDecoration(
                               color: Color(0xFF2B3445),
                               borderRadius: BorderRadius.all(Radius.circular(1))
                             ),
                             height: 50,
                             width: double.infinity,
                             child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                               SizedBox(width: 4,),
                               Icon(Icons.perm_device_information,color: Colors.white,),
                               Text(" v1.0.0"+"",style: TextStyle(color: Colors.white),)
                             ],),
                             
                                ),
                           ),),
                          
                           Expanded(child: Padding(
                             padding: const EdgeInsets.only(left:2,right: 3,bottom: 4),
                             child: InkWell(
                               onTap: () => Navigator.of(context).pop(),
                               child: Container(
                             decoration: BoxDecoration(
                               color: Color(0xFF2B3445),
                               borderRadius: BorderRadius.all(Radius.circular(1))
                             ),  
                             height: 50,
                             width: double.infinity,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                               SizedBox(width: 4,),
                               Icon(Icons.exit_to_app,color: Colors.white,),
                               Text(" "+AppLocalizations.of(context).translate('close'),style: TextStyle(color: Colors.white),)
                             ],),
                         ),
                             )
                           ),),
                           
                       
                   ],
                   ),
               ))


               ],
             ),
            
           ),
          
         ),
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
         body: Column(
         children: <Widget>[
           betFiltre(),   
           SizedBox(height: 2,), 
           Flexible(child: tahminler(),)
         ],
       ),
       )
    );
  }

  Widget betFiltre(){
    return Row(
             children: <Widget>[
               // ******* Futbol ********** //
               Expanded(child: Padding(
                 padding: const EdgeInsets.only(left: 10,right: 5,top: 7,bottom: 3),
                 child: InkWell(
                   onTap: () {
                     setState(() {
                      if(butonRenkleri[0] == Colors.grey){
                        setState(() {
                          butonRenkleri[0] = Colors.green;
                          opacity[0] = 0.8;
                          filtre = "Futbol";  
                        });
                      }else{
                        setState(() {
                          butonRenkleri[0] = Colors.grey;
                          opacity[0] = 0.1;  
                          filtre= "All";
                        });
                      }
                      butonRenkleri[1] = Colors.grey;
                      opacity[1] = 0.1; 
                     });
                   },
                   child: Container(height: 50,width: double.infinity,
                 decoration: BoxDecoration(
                   image: DecorationImage(image: AssetImage("assets/futbol.jpg"),fit: BoxFit.cover,
                   colorFilter: ColorFilter.mode(Colors.black.withOpacity(opacity[0]),BlendMode.dstATop)),
                   color: butonRenkleri[0],
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(child: Text(AppLocalizations.of(context).translate('futbol'),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),),
                 ),
                 ),
               ),),
               //****** BASKETBOL  ********//
                Expanded(child: Padding(
                 padding: const EdgeInsets.only(left: 5,right: 5,top: 7,bottom: 3),
                 child: InkWell(
                   onTap: () {
                     setState(() {
                      if(butonRenkleri[1] == Colors.grey){
                        setState(() {         
                          butonRenkleri[1] = Colors.orange;
                          opacity[1] = 0.8;  
                          filtre = "Basketbol";
                        });
                      }else{
                        setState(() {
                          butonRenkleri[1] = Colors.grey;
                          opacity[1] = 0.1;
                          filtre="All";  
                        });
                      }
                        butonRenkleri[0] = Colors.grey;
                        opacity[0] = 0.1; 
                     });
                   },
              
                   child: Container(height: 50,width: double.infinity,
                 decoration: BoxDecoration(
                   image: DecorationImage(image: AssetImage("assets/basket.png"),fit: BoxFit.cover,
                   colorFilter: ColorFilter.mode(Colors.black.withOpacity(opacity[1]),BlendMode.dstATop)),
                   color: butonRenkleri[1],
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(child: Text(AppLocalizations.of(context).translate('basketbol'),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),),
                 ),
                 ),
               ),),
               /********* LIVE BET  **********/
               Expanded(child: Padding(
                 padding: const EdgeInsets.only(left: 5,right: 10,top: 7,bottom: 3),
                 child: InkWell(
                   onTap: () {
                     getLive().then((liste){
                       Navigator.push(context, MaterialPageRoute(builder:(context) => LiveScore(liste)));
                     });
                   },
                   child: Container(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
                      Icon(FontAwesomeIcons.fire,color: Colors.red,),
                     Text(""+ AppLocalizations.of(context).translate("live_tips")+" ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                    ],),
                    height: 50,width: double.infinity,
                 decoration: BoxDecoration(
                   color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                 ),
                 )
               ),),
             ],
           );
  }

  Widget tahminler() {
    return FutureBuilder(
                 future: filtre == "All" ? getData() : filtre == "Futbol" ? getFutbol() : getBasketbol(),
                 builder: (BuildContext context,snapshot){
                   if(snapshot.hasData){
                     return Column(
                       children: <Widget>[
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
                                             Icon(Icons.access_time,color: Colors.white,),
                                             Text(" " + snapshot.data[index].saat + " ",style: TextStyle(color: Colors.white,),),
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
                                                           color: Colors.blue
                                                       ),
                                                       child: Padding(padding: EdgeInsets.all(5),
                                                           child: liste[index].tur == "Ucretsiz"
                                                               ? 
                                                               snapshot.data[index].oran == 0.1
                                                               ? Text("---",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                                               :Text(snapshot.data[index].oran.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                                               : Text("***",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                                               
                                                       ),

                                                     ),
                                                   )
                                                 ],),
                                             )

                                           ],),
                                       ),

                                       //2.Kısım // Tarih
                                       Padding(
                                         padding: EdgeInsets.only(top: 6,left: 4),
                                         child: Row(children: <Widget>[
                                           Icon(Icons.date_range,color: Colors.white,),
                                           Text(" " + snapshot.data[index].tarih,style: TextStyle(color: Colors.white,)),
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
                                           )  ,
                                         ],),),

                                       //3.Kısım // Mac Kodu - Spor
                                       Padding(
                                         padding: EdgeInsets.only(top: 6,left: 4,bottom: 4),
                                         child: Row(children: <Widget>[
                                           Text(" "+snapshot.data[index].kod.toString()+"  ",style: TextStyle(color: Colors.white,)),
                                           snapshot.data[index].spor == "Futbol"
                                               ? Image.asset("assets/spor/futbol.png",height: 35,width: 35,)
                                               : Image.asset("assets/spor/basketball.png",height: 25,width: 35,),
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
                                                     ? Text(" "+snapshot.data[index].tahmin,style: TextStyle(fontWeight: FontWeight.bold,
                                                     color: snapshot.data[index].durum == "Beklemede"
                                                         ? Colors.orangeAccent
                                                         : snapshot.data[index].durum == "Lose"
                                                         ? Colors.redAccent
                                                         : Colors.greenAccent)
                                                 )
                                                     :Text(AppLocalizations.of(context).translate('vip_match')+ " ",style: TextStyle(color:Colors.orangeAccent,fontWeight: FontWeight.bold)),
                                               ],)
                                           ),

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
                                           )
                                         ],),),
                                     ],
                                   ),
                                 ),
                               );
                             },
                           ),
                         ),
                         AdmobBanner(
                           adUnitId: bannerUnitId,
                           adSize: AdmobBannerSize.FULL_BANNER,
                         ),
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