import 'dart:ui' as prefix0;

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool internet = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _checkInternetConnectivity();
    return Scaffold(
      body: Container(
        child: Column(
        children: <Widget>[
          Center(
            heightFactor: SizeConfig.blockSizeVertical*0.90,
            child: Text('Hoş Geldiniz',
            style:TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w800,
              color: Colors.white
              ),
              ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*2,),
          Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical, horizontal: SizeConfig.blockSizeHorizontal*5),
            child: Text('Doci Boşnak Mutfağını kullandığınız için teşekkür ederiz.' +
            '\n Bu uygulamayı kullanarak siparişinizi daha hızlı verebilir, Eski siparişlerinizi görebilirsiniz.',
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,),
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
      floatingActionButton:SizedBox(
        height: 50,
        width: SizeConfig.blockSizeHorizontal*100,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton.extended(
                backgroundColor: Colors.lightBlueAccent,
                label: Text('Misafir olarak devam et'),
                onPressed: ()=>Navigator.of(context).pushReplacementNamed('/home'),
              ),
            ]),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeHorizontal * 20,
        color: Colors.lightBlueAccent,
        child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  height: SizeConfig.blockSizeHorizontal * 30,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      internet == false ? _checkInternetConnectivity() :
                      Navigator.of(context).pushReplacementNamed("/register");
                    },
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.00),
                    ),
                    color: Colors.lightBlueAccent,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: const Text(
                          'GİRİŞ YAP',
                          style: TextStyle(fontSize: 15)
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal*10,),
                ButtonTheme(
                  height: SizeConfig.blockSizeHorizontal * 20,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      internet == false ? _checkInternetConnectivity() :
                      Navigator.of(context).pushReplacementNamed("/register");
                    },
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
          ],
        )
      ),
    );
  }
  _checkInternetConnectivity() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      internet = false;
       return Alert(
          context:context,
          type: AlertType.error,
          desc: 'Şu an herhangi bir internet bağlantınız bulunmamaktadır. Uygulamayı kullanabilmeniz için internet '
              'bağlantısı gereklidir.',
          title: '',
          buttons: [
            DialogButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ]
      ).show();
    }
    internet = true;
  }


}
