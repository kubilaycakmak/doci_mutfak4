import 'package:doci_mutfak4/Connection/api_calls.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool inside = true;
var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage,height: SizeConfig.blockSizeVertical*10,);
class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
  
}
class _ProfileState extends State<Profile> {
  String name;

  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('LastKey', '');
      prefs.setString('LastUsername', '');
      prefs.setString('LastPassword', '');
      setState(() {
        key = null;
        keyShared = null;
      });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title:
              inside == false ? Text('Profilim') : Text('GIRIS YAP / YENI UYE'),
          backgroundColor: Color.fromRGBO(0, 40, 77,1),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromRGBO(0, 40, 77,1),
            child: inside == false
                  ? ListView(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          print(key);
                        },
                        child: image,
                        padding: EdgeInsets.only(bottom: 10),
                        color: Color.fromRGBO(0, 40, 77,1),
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
                            name == null ? "Hoşgeldiniz" :
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
                          color: Color.fromRGBO(0, 40, 77,1),
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
                                postItself(context, '/update');
                              },
                            ),
                            ListTile(
                              title: Text('Şifremi değiştir'),
                              subtitle: Text('Sifre işlemleri'),
                              leading: Icon(Icons.lock_outline),
                              onTap: () {
                                if(keyShared != null){
                                  postItself(context, '/change');
                                }
                              } 
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
                                inside = true;
                                logout();
                                Navigator.of(context).pushReplacementNamed('/splash');
                                print(key);
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