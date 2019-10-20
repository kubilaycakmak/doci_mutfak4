import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/material.dart';
var backgroundImage = new AssetImage('assets/images/me.jpg');
var image = new Image(image: backgroundImage);
bool inside = true;
class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: inside == false ? Text('Profilim') : Text('GIRIS YAP / YENI UYE'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: inside == false ? ListView(
          padding: EdgeInsets.only(top: 20),
          children: <Widget>[
            FlatButton(
              onPressed: (){
                print('asd');
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: image,
                ),
                radius: 80,
              ),
            ),
            Center(
              heightFactor: 3,
              child: Text('Kubilay Cakmak', style: TextStyle(fontSize: 20),),
            ),
            ListTile(
              title: Text('Bilgilerimi Guncelle'),
              subtitle: Text('Sifre - Adres - Telefon numarasi'),
              leading: Icon(Icons.update),
              onTap: null,
            ),
            ListTile(
              title: Text('Eski Siparislerim'),
              subtitle: Text('Son 10 siparisim.'),
              leading: Icon(Icons.history),
              onTap: null,
            ),
            ListTile(
              title: Text('Kaydettigim Siparisler'),
              subtitle: Text('Tek tikla siparisini ver.'),
              leading: Icon(Icons.save),
              onTap: null,
            ),
            ListTile(
              title: Text('Ayarlar'),
              subtitle: Text('Uygulama ayarlari'),
              leading: Icon(Icons.settings),
              onTap: null,
            ),
            ListTile(
              title: Text('Hakkimizda'),
              subtitle: Text('Uygulama Hakkinda'),
              leading: Icon(Icons.info),
              onTap: null,
            ),
            ListTile(
              title: Text('Cikis Yap'),
              leading: Icon(Icons.close),
              onTap: (){
                inside = true;
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ],
        )
        :
        LoginAndRegister()
      )
    );
  }
}