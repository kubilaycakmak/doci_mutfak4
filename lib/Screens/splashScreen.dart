import 'package:connectivity/connectivity.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlueAccent,
        label: Text('Misafir olarak devam et', style: TextStyle(fontSize: 20),),
        onPressed: () => internet == false ? _checkInternetConnectivity() : Navigator.of(context).pushReplacementNamed("/home"),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical*10,
        color: Colors.lightBlueAccent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            ButtonTheme(
              child: FlatButton(
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
          SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),
          ButtonTheme(
              child: FlatButton(
                onPressed: () {
                  internet == false ? _checkInternetConnectivity() :
                  Navigator.of(context).pushReplacementNamed("/login");
                },
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
        ],),
      ),
      body: Container(
        child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*10),
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
            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*10,horizontal: SizeConfig.blockSizeHorizontal*10),
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