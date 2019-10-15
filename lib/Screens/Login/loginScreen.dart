/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController user=new TextEditingController();
  TextEditingController pass=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giris Yap'),
        leading: IconButton(
          onPressed: ()=> Navigator.popAndPushNamed(context, '/splash'),
          icon: Icon(Icons.arrow_back_ios),
          ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 120),
        alignment: Alignment.center,
        child: Column(
         children: <Widget>[
           TextField(
             autofocus: true,
             obscureText: false,
             keyboardType: TextInputType.text,
             controller: user,
             decoration: InputDecoration(
               hintText: 'Kullanici Adi veya E-Posta',
               labelStyle: TextStyle(
                 color: Colors.black12,
                 fontSize: 16
               ),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.all(Radius.circular(4)),
                 borderSide: BorderSide(
                   width: 0.2,
                   color: Colors.black12,
                   style: BorderStyle.solid
                 )
               )
             ),
           ),
           Padding(
             padding: EdgeInsets.only(top: 10),
           ),
           TextField(
             autofocus: true,
             obscureText: false,
             keyboardType: TextInputType.text,
             controller: pass,
             decoration: InputDecoration(
               hintText: 'Sifre',
               labelStyle: TextStyle(
                 color: Colors.black12,
                 fontSize: 16
               ),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.all(Radius.circular(4)),
                 borderSide: BorderSide(
                   width: 0.2,
                   color: Colors.black12,
                   style: BorderStyle.solid
                 )
               )
             ),
           ),
           Expanded(
             child: ButtonBar(
             children: <Widget>[
               FlatButton(
                 onPressed: null,
                 child: Text('Sifremi unuttum'),
               ),
               RaisedButton(
                 onPressed: null,
                 child: Text('Giris Yap'),
               ),
             ],
           ),
           ),
         ],
       ),
      ),
    );
  }
}
*/