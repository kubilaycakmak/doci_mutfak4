import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
bool inside = true;

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{

  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';

  /*Future<http.Response> postItself() async{
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": key,
    });
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
    return response;
  }*/

  @override
  Widget build(BuildContext context) {
    //postItself();
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
                print(key);
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: null,
                ),
                radius: 80,
              ),
            ),
            Center(
              heightFactor: 3,
              child: Text("Hosgeldiniz ", style: TextStyle(fontSize: 20),),
            ),
            ListTile(
              title: Text('Bilgilerimi Guncelle'),
              subtitle: Text('Sifre - Adres - Telefon numarasi'),
              leading: Icon(Icons.update),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/update');
              },
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
              title: Text('Basa don'),
              subtitle: Text('Uygulama Hakkinda'),
              leading: Icon(Icons.info),
              onTap: () => Navigator.of(context).pushReplacementNamed('/splash'),
            ),
            ListTile(
              title: Text('Cikis Yap'),
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