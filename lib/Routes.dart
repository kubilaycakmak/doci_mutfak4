import 'dart:convert';

import 'package:animated_splash/animated_splash.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/Info.dart';
import 'package:doci_mutfak4/Screens/Home/bottom_navi.dart';
import 'package:doci_mutfak4/Screens/Home/contact.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:doci_mutfak4/Screens/Home/shop_cart.dart';
import 'package:doci_mutfak4/Screens/Profile/change_pass.dart';
import 'package:doci_mutfak4/Screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Account/user.dart';
import 'Screens/Home/shop_cart.dart';
import 'Screens/Profile/update.dart';

class Routes{
  Routes(){
    runApp(MaterialApp(
      title: 'Doci Bosnak Mutfagi',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      onGenerateRoute: (RouteSettings settings){
        switch(settings.name){

          case '/register':
          return MyCustomRoute(
            builder: (_) => LoginAndRegister(),
            settings: settings
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

          case '/contact':
          return MyCustomRoute(
            builder: (_) => Contact(),
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
var keyShared;
var username;
var password;
bool switcha;
Map<dynamic, Widget> returnValueAndHomeScreen = {1: HomeScreen(), 2: SplashScreen()};

  getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
    keyShared = prefs.getString('LastKey');
    //print('prefs : ' + username);
    //print('prefs : ' + password);
    if(keyShared != ''){
      setState(() {
        switcha = true;
        postRequesAuto(username, password);
        postItselfAuto(keyShared);
      });
    }
    else{
      setState(() {
        switcha = false;
        logout();
      });
    }
    print(switcha);
  } 

    logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('LastKey', '');
      prefs.setString('LastUsername', '');
      prefs.setString('LastPassword', '');
  }

  

  Future<http.Response> postRequesAuto(String username, String password) async {
      Map data = {
        'username': username,
        'password': password
      };
      var body = json.encode(data);
      var response = await http.post('http://68.183.222.16:8080/api/userAccount/login', headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        authKey = json.decode(response.body);
        key = authKey["authorization"];
        if (key != '') {
          setState(() {
            inside = false;
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else {
          inside = true;
        }
      }
    return response;
  }

  Future<http.Response> postItselfAuto(String keyJson) async {
    var response = await http.get(Uri.encodeFull('http://68.183.222.16:8080/api/user/itself'), headers: {
      "authorization": keyJson,
    });

    if(response.statusCode == 200){
        user = json.decode(response.body);
        var userInfo = User.fromJson(user);
        userInformations.add(userInfo);  
        print(userInformations[0].name);
        return response;
      }else{
        throw Exception('postItselfAuto');
    }
  } 
  @override
  void initState() { 
    super.initState();
    this.getKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        color: Colors.lightBlueAccent,
        child: AnimatedSplash(
          imagePath: 'assets/images/logo.png',
          home: SplashScreen(),
          customFunction: (){
            if (!switcha) {
              return 2;
            } else {
              return 1;
            } 
          },
          duration: 2500,
          type: AnimatedSplashType.BackgroundProcess,
          outputAndHome: returnValueAndHomeScreen,
        ),
      ),
    );
  }
}