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
            child: Text('Hoş Geldiniz', 
            style:TextStyle(
              fontSize: 35, 
              fontWeight: FontWeight.w400, 
              color: Colors.white
              ),
              ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35, top: 50),
            child: Text('Doci Boşnak Mutfağını kullandığınız için teşekkür ederiz.' +  
            '\n Bu uygulamayı kullanarak siparişinizi daha hızlı verebilir, Eski siparişlerinizi görebilirsiniz.', 
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
                      padding: EdgeInsets.only(top: 100),
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
                                  borderRadius: BorderRadius.circular(10.00),
                                ),
                                color: Colors.lightBlueAccent,
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: const Text(
                                  'YENİ ÜYE',
                                  style: TextStyle(fontSize: 15)
                                ),
                              ),
                            ),
                          ),
                          ButtonTheme(
                              child: RaisedButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.00),
                                  side: BorderSide(color: Colors.lightBlueAccent)
                                ),
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: const Text(
                                  'GİRİŞ YAP',
                                  style: TextStyle(fontSize: 15)
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                        FlatButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
                      textColor: Colors.white,
                      child: const Text('Misafir olarak devam et',style: TextStyle(fontSize: 25)),
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
            color: Colors.lightBlue,
            image: DecorationImage(
            image: backgroundImage,
            alignment: Alignment.topCenter,
            repeat: ImageRepeat.repeat,
            fit: BoxFit.scaleDown,
            colorFilter: ColorFilter.mode(Colors.black54.withOpacity(0.1), BlendMode.dstATop)
          )
        ),
      ),
    );
  }
}