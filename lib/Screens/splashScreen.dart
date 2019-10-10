import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    
    TextEditingController emailEditingContrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var backgroundImage = new AssetImage('assets/images/yemek.jpg');
    var image = new Image(image: backgroundImage,fit: BoxFit.cover);
    return Scaffold(
      body: Container(
        child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Center(
            child: Text('Hos Geldiniz', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 50),
            child: Text('Doci Bosnak Mutfagi mobil uygulamasina hosgelniz. Bu uygulama ile hizli bir sekilde siparisinizi verebilirsiniz.', 
              style: TextStyle(fontSize: 20, color: Colors.white), 
              textAlign: TextAlign.center,),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  ],
                ),
              ),
            ),
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ButtonTheme(
                minWidth: 120,
                height: 50,
                child: RaisedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, "/register"),
                child: Text('YENI UYE'),
              ),
              ),
              ButtonTheme(
                minWidth: 120,
                height: 50,
                child: RaisedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                child: Text('Giris Yap'),
              ),
              ),
            ],
          ),
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
            child: Text('Daha Sonra >', style: TextStyle(color: Colors.white, fontSize: 20),),
          )
        ],
      ),
      decoration: BoxDecoration(
              color: Colors.black,
            image: DecorationImage(
              image: backgroundImage,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop)
            )
        ),
      ),
    );
  }
}