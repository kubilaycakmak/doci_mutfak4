import 'package:doci_mutfak4/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

main() async {

  ErrorWidget.builder = (FlutterErrorDetails details) => Container(child:Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.lightBlueAccent,
      title: Text('Hata'),
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
       child: Center(
         child: Column(
           children: <Widget>[
             ListTile(
               subtitle: Text('Bir şeyler ters gitti.'),
             ),
             SizedBox(height: 20,),
             CupertinoButton(
               child: Text('Ana menüden devam et'),
               onPressed: ()=> Navigator.of(context).pushReplacementNamed('/splash'),
             )
           ],
         ),
       ),
    );
  }
}