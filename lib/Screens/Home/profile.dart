import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool inside = true;
var statusCode;

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);

class _ProfileState extends State<Profile> {
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';

  Future<http.Response> postItself() async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": key,
    });
    if (response.statusCode == 200) {
      user = json.decode(response.body);
      var userInfo = new User(
          id: user["value"]["id"],
          name: user["value"]["name"],
          lastname: user["value"]["lastname"],
          phoneNumber: user["value"]["phoneNumber"],
          address: user["value"]["address"],
          created: user["value"]["created"]);
      userInformations.clear();
      userInformations.add(userInfo);
    }
    return response;
  }

  @override
  void dispose() {
    this.postItself();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      postItself();
    });
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title:
              inside == false ? Text('Profilim') : Text('GIRIS YAP / YENI UYE'),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
            child: inside == false
                ? ListView(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          print(key);
                        },
                        child: image,
                        color: Colors.lightBlueAccent,
                      ),
                      Center(
                        heightFactor: 3,
                        child: Text(
                          "Hosgeldiniz ",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      ListTile(
                        title: Text('Bilgilerimi Güncelle'),
                        subtitle: Text('Ad - Soyad - Adres - Telefon numarası'),
                        leading: Icon(Icons.update),
                        onTap: () {
                          setState(() {
                            postItself();
                          });
                          Navigator.of(context).pushReplacementNamed('/update');
                        },
                      ),
                      ListTile(
                        title: Text('Şifremi değiştir'),
                        subtitle: Text('Sifre işlemleri'),
                        leading: Icon(Icons.settings),
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('/change'),
                      ),
                      ListTile(
                        title: Text('Hakkımızda'),
                        subtitle: Text('Lokasyonumuz - iletişim bilgileri'),
                        leading: Icon(Icons.info),
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('/info'),
                      ),
                      ListTile(
                        title: Text('Çıkış Yap'),
                        subtitle: Text('Güle güle'),
                        leading: Icon(Icons.close),
                        onTap: () {
                          setState(() {
                            inside = true;
                            key = null;
                            userInformations.clear();
                          });
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                      ),
                    ],
                  )
                : LoginAndRegister()));
  }
}
