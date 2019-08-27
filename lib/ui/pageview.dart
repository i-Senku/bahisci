import 'package:flutter/material.dart';
import 'dart:async';

class PageviewWidget extends StatefulWidget {
  @override
  _PageviewWidgetState createState() => _PageviewWidgetState();
}

class _PageviewWidgetState extends State<PageviewWidget> {
  PageController _pageController;
  int _page=0;
  Timer timer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _page);
    timer = Timer.periodic(Duration(seconds: 4), (t){
      if(_page<2){
        setState(() {
          _page++; 
          _pageController.animateToPage(_page,duration: Duration(milliseconds: 500),curve:Curves.linear).then((_){           
          }); 
        });
      }else{
        setState(() {
         _page = 0;
          _pageController.animateToPage(_page,duration: Duration(milliseconds: 500),curve:Curves.linear).then((_){           
          });
        });
      }
      print(_page);
    });
    _pageController.addListener((){
      print(_pageController.page);
    });
    
  }

  @override 
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
      Container(
      height: 170,
      child: PageView(
        onPageChanged: (value){
          setState(() {
           _page = value; 
          });
        },
        controller: _pageController,
        children: <Widget>[
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color:  Colors.red ,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Stack(
              children: <Widget>[],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
        ),
        ],
      ),
      ),
      Positioned(
        bottom: 15,
        left: 160,
        child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: _page == 0 ? Colors.amber : Colors.white54,
          borderRadius: BorderRadius.all(Radius.circular(40))
        ),
      ),
      ),
      Positioned(
        bottom: 15,
        left:  190,
        child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: _page == 1 ? Colors.amberAccent : Colors.white54,
          borderRadius: BorderRadius.all(Radius.circular(40))
        ),
      ),
      ),
      Positioned(
        bottom: 15,
        left: 220,
        child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: _page == 2 ? Colors.amberAccent : Colors.white54,
          borderRadius: BorderRadius.all(Radius.circular(40))
        ),
      ),
      )
      
      ],
    );
  }
}