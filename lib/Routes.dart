import 'package:animated_splash/animated_splash.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/bottom_navi.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Profile/change_pass.dart';
import 'package:doci_mutfak4/Screens/Profile/info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Connection/api_calls.dart';
import 'Screens/Profile/profile.dart';
import 'Screens/Profile/update.dart';
import 'Screens/ShopCart/shop_cart.dart';
import 'splashScreen.dart';

class Routes{
  Routes(){
    runApp(MaterialApp(
      title: 'Doci Bosnak Mutfagi',
      debugShowCheckedModeBanner: false,
      home: EntryScreen(),
      onGenerateRoute: (RouteSettings settings){
        switch(settings.name){

          case '/register':
          return MyCustomRoute(
            builder: (_) => LoginAndRegister(),
            settings: settings,
          );

          case '/info':
          return MyCustomRoute(
            builder: (_) => Info(),
            settings: settings
          );

          case '/forget':
            return MyCustomRoute(
                builder: (_) => ForgetPassword(),
                settings: settings
            );

          case '/change':
            return MyCustomRoute(
                builder: (_) => ChangePassword(),
                settings: settings
            );

          case '/menu':
          return MyCustomRoute(
            builder: (_) => Menu(),
            settings: settings
          );

          case '/cart':
          return MyCustomRoute(
              builder: (_) => ShoppingCart(),
              settings: settings
          );

          case '/endcart':
            return MyCustomRoute(
                builder: (_) => EndOfTheShoppingCart(),
                settings: settings
            );

          case '/splash':
          return MyCustomRoute(
            builder: (_) => SplashScreen(),
            settings: settings
          );

          case '/login':
          return MyCustomRoute(
            builder: (_) => LoginAndRegister(),
            settings: settings,
          );

          case '/profile':
          return MyCustomRoute(
            builder: (_) => Profile(),
            settings: settings,
          );

          case '/home':
          return MyCustomRoute(
            builder: (_) => HomeScreen(),
            settings: settings,
          );

          case '/entry':
          return MyCustomRoute(
            builder: (_) => EntryScreen(),
            settings: settings,
          );

          case '/update':
          return MyCustomRoute(
            builder: (_) => Update(),
            settings: settings,
          );
        }
        return null;
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T>{
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
    : super(builder: builder, settings: settings);
}

class EntryScreen extends StatefulWidget {
  
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
Map<dynamic, Widget> returnValueAndHomeScreen = {1: HomeScreen(), 2: SplashScreen()};

var keyShared;
var username;
var password;
static bool switcha;
GlobalKey _scaffold = GlobalKey();

Function duringSplash = () {
  if (switcha == false) {
    return 2;
  } else {
    return 1;
  } 
};

  getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
    keyShared = prefs.getString('LastKey');
    if(username == null || username == ''){
      setState(() {
        switcha = false;
      });
    }else{
      setState(() {
        switcha = true;
      });
    }
    // if(keyShared != ''){
    //   setState(() {
    //     postRequestAuto(context,username, password);
    //     postItselfAuto(keyShared);
    //     switcha = false;
    //   });
    // }
    // else{
    //   setState(() {
    //     switcha = true;
    //     logout();
    //     //Navigator.of(context).pushReplacementNamed('/entry');
    //   });
    // }
  } 
  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('LastKey', '');
      prefs.setString('LastUsername', '');
      prefs.setString('LastPassword', '');
      key = null;
      switcha = false;
  }

    @override
  void initState() { 
    super.initState();
    this.getKey();
  }
  @override
  void dispose() {
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    key: _scaffold,
    backgroundColor: Colors.deepOrangeAccent.shade700,
    body: Container(
      color: Colors.deepOrangeAccent.shade700,
      child: AnimatedSplash(
        imagePath: 'assets/images/logo.png',
        home: SplashScreen(),
        duration: 2500,
        customFunction: duringSplash,
        type: AnimatedSplashType.BackgroundProcess,
        outputAndHome: returnValueAndHomeScreen,
      ),
    ),
  );
}
}