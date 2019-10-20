import 'package:doci_mutfak4/Screens/Home/bottom_navi.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
TabController tabController;
class LoginAndRegister extends StatefulWidget {
  @override
  _LoginAndRegisterState createState() => _LoginAndRegisterState();
}

class _LoginAndRegisterState extends State<LoginAndRegister> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);
    var tabBarItem = new TabBar(
      tabs: <Widget>[
        Tab(
          child: Text('Giris Yap'),
        ),
        Tab(
          child: Text('Yeni Uye'),
        )
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          bottom: tabBarItem,
          backgroundColor: Colors.lightBlueAccent,
        ),
        
        ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  enabled: false,
                  leading: Icon(Icons.info_outline),
                  subtitle: Text('Bu uygulama diger uygulamalardan bagimsiz olup kendi uyeliginizi kullanmaniz gerekmektedir.'),
                  ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Kullanici Adi veya E-Posta",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "E-posta veya Kullanici adi bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Sifre",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "E-posta veya Kullanici adi bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        leading: FlatButton(onPressed: (){}, child: Text('Sifremi Unuttum!'),),
                        trailing: MaterialButton(
                          onPressed: (){
                            inside = false;
                            Navigator.of(context).pushReplacementNamed('/home');
                            print('asd');
                        }, child: Text('Giris Yap'),color: Colors.lightBlueAccent,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  enabled: false,
                  leading: Icon(Icons.info_outline),
                  subtitle: Text('Bu uygulama diger uygulamalardan bagimsiz olup kendi uyeliginizi kullanmaniz gerekmektedir.'),
                  ),
                  ListTile(
                  contentPadding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  enabled: false,
                  leading: Icon(Icons.info_outline),
                  subtitle: Text('Bu uygulama diger uygulamalardan bagimsiz olup kendi uyeliginizi kullanmaniz gerekmektedir.'),
                  ),
                  
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "E-Posta",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "E-posta bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Sifre",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "Sifre bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Sifre Tekrar",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "Sifre bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ad",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "Ad bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Soyad",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "Soyad bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Dogum Tarihi",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "Dogum Tarihi Bos olamaz";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        maxLength: null,
                        decoration: InputDecoration(
                          labelText: "Adres",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "Adres bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                        enabled: false,
                        contentPadding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        subtitle: Text('Bilgilerinizi profilim sayfanizdan degistirebilirsiniz.'),
                        ),
                      ListTile(
                        enabled: false,
                        contentPadding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        subtitle: Text('Kullanici Sozlesmesini ve Gizlilik Politikasini okudum ve kabul ediyorum.'),
                      ),
                      ListTile(
                        title: MaterialButton(onPressed: (){print('Giris yapildi');}, child: Text('Yeni Uye'),color: Colors.lightBlueAccent,),
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