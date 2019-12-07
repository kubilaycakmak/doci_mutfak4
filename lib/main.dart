import 'package:doci_mutfak4/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var backgroundImage = new AssetImage('assets/images/404.png');
var image = new Image(image: backgroundImage, fit: BoxFit.fitWidth,);

main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ErrorWidget.builder = (FlutterErrorDetails details) => Container(child:Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromRGBO(0, 40, 77,1),
      title: Text('Hata Sayfası'),
      elevation: 0,
    ),
    body: ErrorHandlingPage()
  ));
  Routes();
}

class ErrorHandlingPage extends StatefulWidget {
  ErrorHandlingPage({Key key}) : super(key: key);

  @override
  _ErrorHandlingPageState createState() => _ErrorHandlingPageState();
}



class _ErrorHandlingPageState extends State<ErrorHandlingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 40, 77,1),
       child: Center(
         child: Column(
           children: <Widget>[
             ListTile(
               subtitle: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   image,
                 Text('Opps!, Bir şeyler ters gitti.', style: TextStyle(color: Colors.white, fontSize: 25),),
               ],)
             ),
             SizedBox(height: 20,),
             MaterialButton(
               color: Colors.white,
               child: Text('Ana menüden devam et'),
               onPressed: ()=> Navigator.of(context).pushReplacementNamed('/home'),
             )
           ],
         ),
       ),
    );
  }
}