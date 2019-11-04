import 'package:doci_mutfak4/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var errorMessagetoFixController = new TextEditingController();

main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorScreen();
  Routes();
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        home: Container(
          color: Colors.white,
          child: FlatButton(child: ListTile(
            title: Text('Hata Sayfası'),
            subtitle: Text('Lütfen ekrana tıklayarak ana menüye dönünüz.'),
          ), onPressed: ()=> Navigator.of(context).pushReplacementNamed('/home'))
      ),
    );
  }
}