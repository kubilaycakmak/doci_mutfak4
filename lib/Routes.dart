import 'package:doci_mutfak4/Screens/Home/Info.dart';
import 'package:doci_mutfak4/Screens/Home/contact.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/shoppingCart.dart';
import 'package:doci_mutfak4/Screens/Login/json_restful_api.dart';
import 'package:doci_mutfak4/Screens/Login/registerScreen.dart';
import 'package:doci_mutfak4/Screens/Home/HomeScreen.dart';
import 'package:doci_mutfak4/Screens/splashScreen.dart';
import 'package:flutter/material.dart';

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
            builder: (_) => RegisterScreen(),
            settings: settings
          );

          case '/info':
          return MyCustomRoute(
            builder: (_) => Info(),
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

          case '/splash':
          return MyCustomRoute(
            builder: (_) => SplashScreen(),
            settings: settings
          );

          case '/login':
          return MyCustomRoute(
            builder: (_) => LoginWithRestfulApi(),
            settings: settings,
          );

          case '/home':
          return MyCustomRoute(
            builder: (_) => HomeScreen(),
            settings: settings,
          );
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T>{
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
    : super(builder: builder, settings: settings);
}