import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  var keyShared;
  String name;
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';

    Future<http.Response> postRequestAuto(String username, String password) async {
      Map data = {
        'username': username,
        'password': password
      };
      var body = json.encode(data);
      var response = await http.post('http://68.183.222.16:8080/api/userAccount/login', headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        authKey = json.decode(response.body);
        key = authKey["authorization"];
        if (key != '') {
          setState(() {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else {
        }
      }
    return response;
  }

  Future<http.Response> postItself() async{
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": key,
    });

    if(response.statusCode == 200){
      user = json.decode(response.body);
      var userInfo = new User(
          id: user["value"]["id"],
          name: user["value"]["name"],
          lastname: user["value"]["lastname"],
          phoneNumber: user["value"]["phoneNumber"],
          address: user["value"]["address"],
          created: user["value"]["created"]
      );
      userInformations.clear();
      userInformations.add(userInfo);
      print(userInformations[0].name);
      setState(() {
        name = userInformations[0].name;
      });
    }else if(response.statusCode == 401){
      postRequestAuto(username, password);
    }
    print(response.statusCode);
    
    return response;
  }

  getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
  }

  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LastKey', '');
    prefs.setString('LastUsername', '');
    prefs.setString('LastPassword', '');
  }

  @override
  void dispose() {
    this.postItself();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.postItself();
    this.getKey();
  }

  @override
  Widget build(BuildContext context) {
    //postItself();
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title:
              inside == false ? Text('Profilim') : Text('GIRIS YAP / YENI UYE'),
          backgroundColor: Colors.deepOrangeAccent.shade700,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.deepOrangeAccent.shade700,
            child: inside == false
                  ? ListView(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          print(key);
                        },
                        child: image,
                        padding: EdgeInsets.only(bottom: 10),
                        color: Colors.deepOrangeAccent.shade700,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          heightFactor: 2,
                          child: Text(
                            name == null ? "Hoşgeldin" :
                            "Hoşgeldin $name",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      ),
                      Container(
                        child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.deepOrangeAccent.shade700,
                          width: 1,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('Bilgilerimi Güncelle'),
                              subtitle: Text('Ad - Soyad - Adres - Telefon numarası'),
                              leading: Icon(Icons.info_outline),
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
                              leading: Icon(Icons.lock_outline),
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/change'),
                            ),
                            ListTile(
                              title: Text('Hakkımızda'),
                              subtitle: Text('Lokasyonumuz - iletişim bilgileri'),
                              leading: Icon(Icons.map),
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/info'),
                            ),
                            SizedBox(height: 10,),
                            CupertinoButton(
                              color: Colors.redAccent,
                              pressedOpacity: 0.5,
                              child: Text('Çıkış Yap', textAlign: TextAlign.center,),
                              onPressed: () {
                                setState(() {
                                  logout();
                                  inside = true;
                                  key = '';
                                  keyShared = '';
                                  userInformations.clear();
                                });
                                Navigator.of(context).pushReplacementNamed('/home');
                              },
                            ),
                          ],
                        ),
                        )
                      ),
                      padding: EdgeInsets.all(10),
                      ),
                    ],
            )
                : LoginAndRegister()));
  }
}