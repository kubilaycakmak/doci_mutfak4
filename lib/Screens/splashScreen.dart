import 'package:flutter/material.dart';

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);
class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    TextEditingController emailEditingContrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 180),
          ),
          Center(
            child: Text('Hos Geldiniz', 
            style:TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.w700, 
              color: Colors.white
              ),
              ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 50),
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
                    Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Column(
                        children: <Widget>[
                          ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            ButtonTheme(
                              child: RaisedButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, "/register"),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.00),
                                ),
                                color: Colors.lightBlueAccent,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: const Text(
                                  'YENI UYE',
                                  style: TextStyle(fontSize: 20)
                                ),
                              ),
                            ),
                          ),
                          ButtonTheme(
                              child: RaisedButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.00),
                                  side: BorderSide(color: Colors.lightBlueAccent)
                                ),
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: const Text(
                                  'GIRIS YAP',
                                  style: TextStyle(fontSize: 20)
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                        FlatButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
                      textColor: Colors.white,
                      child: const Text('Daha Sonra',style: TextStyle(fontSize: 25)),
                    ),
                      ],
                    )
                    ),
                  ],
                ),
              ),
            ),
          ),
          
        ],
      ),
      decoration: BoxDecoration(
              color: Colors.black,
            image: DecorationImage(
              image: backgroundImage,
              alignment: Alignment.topCenter,
              repeat: ImageRepeat.repeat,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop)
            )
        ),
      ),
    );
  }
}