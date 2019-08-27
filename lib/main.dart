import 'dart:core';
import 'package:banko_mac/splashscren.dart';
import 'package:banko_mac/version_page.dart';
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'myapp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:banko_mac/models/spor.dart';
import 'package:version/version.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future<List<Match>> getData() async {
    var response = await http.get(url);
    if(response.statusCode == 200){
      var data = (json.decode(response.body) as List).map((data) => Match.fromJson(data)).toList();
      return data;
    }else{
      throw "Hata : ${response.statusCode}";
    }  
  }
Future<String> getVersion() async{
  var response = await http.get("https://mypinky.net/bankomac/version.txt");
  print(response.body);
  return response.body;
}
Future<bool> control() async{
  Version currentVersion =  Version(3,0,0);
  Version latestVersion;
  latestVersion = Version.parse(await getVersion());

  if(latestVersion > currentVersion){
    return true;
  }else{
    return false;
  }
}

main() async{
  List<Match> liste;

  control().then((control){

      if(control){
        runApp(MaterialApp( title: "BankoMac - Betting Tips",debugShowCheckedModeBanner: false,home: VersionPage(),));
    }else{
      getData().then((list){  
        liste = list;
        runApp(MaterialApp(
          title: "BankoMac - Betting Tips",
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            Locale('en','US'),
            Locale('tr','TR'),   
          ] ,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale,supportedLocales){
            for(var supportedLocale in supportedLocales){
              if(supportedLocale.languageCode == locale.languageCode && 
                supportedLocale.countryCode == locale.countryCode){
                  return supportedLocale;
                }
            }
              return supportedLocales.first;
          },
      home: SplashApp(liste),));
      });    
    }
  });

} 