import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
bool inside = true;

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);

class _ProfileState extends State<Profile>{

  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';

  @override
  Widget build(BuildContext context) {
    //postItself();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: inside == false ? Text('Profilim') : Text('GIRIS YAP / YENI UYE'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: inside == false ? ListView(
          children: <Widget>[
            FlatButton(
              onPressed: (){
                print(key);
              },
              child: image,
              color: Colors.lightBlueAccent,
            ),
            Center(
              heightFactor: 3,
              child: Text("Hosgeldiniz ", style: TextStyle(fontSize: 20),),
            ),
            ListTile(
              title: Text('Bilgilerimi Güncelle'),
              subtitle: Text('Ad - Soyad - Adres - Telefon numarası'),
              leading: Icon(Icons.update),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/update');
              },
            ),
            ListTile(
              title: Text('Kayıtlı Siparişler'),
              subtitle: Text('Tek tıkla siparişin sepette'),
              leading: Icon(Icons.save),
              onTap: null,
            ),
            ListTile(
              title: Text('Şifremi değiştir'),
              subtitle: Text('Sifre işlemleri'),
              leading: Icon(Icons.settings),
              onTap: null,
            ),
            ListTile(
              title: Text('Hakkımızda'),
              subtitle: Text('Lokasyonumuz - iletişim bilgileri'),
              leading: Icon(Icons.info),
              onTap: null,
            ),
            ListTile(
              title: Text('Çıkış Yap'),
              subtitle: Text('Güle güle'),
              leading: Icon(Icons.close),
              onTap: (){
                inside = true;
                print(key);
                key = null;
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