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