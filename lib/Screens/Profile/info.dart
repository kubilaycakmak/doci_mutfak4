import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';
import 'package:doci_mutfak4/Connection/api_calls.dart';
class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int number = 02123970488;
  void call(String number) => launch("tel:$number");
  void map(String url) => UrlLauncher.launch('url:$url');
  String googleMapsApiKey = 'AIzaSyDPmrcF0KrfLKnTd-zDjj4IqNF3_sYGap8';

  
  @override
  void initState() {
    super.initState();
    storeOpenorNot(); 
  }

  @override
  Widget build(BuildContext context) {
    print(storeOpenorNot());
    //AIzaSyDPmrcF0KrfLKnTd-zDjj4IqNF3_sYGap8
    return WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          Navigator.of(context).pushReplacementNamed('/home');
        },
      child : Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            FloatingActionButton.extended(
              backgroundColor: Colors.yellow.shade900,
              onPressed: ()=> call('02123970488'),
              label: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.phone),
                    SizedBox(width: 10,),
                    Text('Bizi ara')
                  ],
                ),
              ),
            ),
          ],
        ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: Text('Hakkımızda'),
        elevation: 0,
        backgroundColor: Color.fromRGBO(0, 40, 77,1),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(0, 40, 77,1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.timeline),
                  title: Text('Servis Saati'),
                  subtitle: Text('09:00 - 23:00'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.store),
                  title: Text('Durum'),
                  subtitle: isOpened == false ? Text('KAPALI', style: TextStyle(backgroundColor: Colors.red, color: Colors.white),) : Text('ACIK', style: TextStyle(backgroundColor: Colors.green, color: Colors.white),),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.timelapse),
                  title: Text('Servis Süresi'),
                  subtitle: Text('Max. 45 DK'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(Icons.map),
                  title: Text('Adres'),
                  subtitle: SelectableText('Atakent, 223. Cadde No:3, 34307 Küçükçekmece/İstanbul'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Telefon'),
                  subtitle: SelectableText('(0212) 397 04 88'),
                ),
              )
            ],
            ),
          ),
      ),
    );
  }
}