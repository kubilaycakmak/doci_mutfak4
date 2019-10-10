import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailEditingController = TextEditingController();

  String _color = '';
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Uye'),
        leading: IconButton(
          onPressed: ()=> Navigator.popAndPushNamed(context, '/splash'),
          icon: Icon(Icons.arrow_back_ios),
          ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 26),
            children: <Widget>[
              new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Lutfen E-Postanizi girin',
                      labelText: 'E-Posta',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Sifrenizi girin',
                      labelText: 'Sifre',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Sifrenizi girin',
                      labelText: 'Sifre',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Adinizi Girin',
                      labelText: 'Ad',
                    ),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Soyadinizi Girin',
                      labelText: 'Soyad',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Dogum Tarihinizi girin',
                      labelText: 'Dogum Tarihi',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Telefon numaranizi girin',
                      labelText: 'Telefon numarasi',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  new TextFormField(
                    maxLength: 200,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Adresinizi Girin',
                      labelText: 'Adres',
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  new Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Kullanici Sozlesmesini ve Gizlilik Politikasini okudum ve kabul ediyorum.'),
                  ),
                  new Container(
                      padding: EdgeInsets.only(top: 20),
                      child: new RaisedButton(
                        child: const Text('Yeni Uye'),
                        onPressed: null,
                      )
                      ),
            ],
          ),
        ),
      ),
    );
  }
}