import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:doci_mutfak4/Screens/Home/shop_cart.dart';
import 'package:flutter/material.dart';
import 'last_orders.dart';
import 'menu.dart';

int _currentIndex = 1;
class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<bool> _onBackPressed(){
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text('Uygulamadan çıkmak mı istiyorsunuz?'),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=> Navigator.pop(context,true),
            child: Text('Evet'),
          ),
          FlatButton(
            onPressed: ()=> Navigator.pop(context,false),
            child: Text('Hayır'),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Profile(),
      Menu(),
      LastOrders(),
      ShoppingCart(),
    ];

    return WillPopScope(
      onWillPop: _onBackPressed,
          child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: false,
          backgroundColor: Colors.lightBlueAccent,
          onItemSelected: (index){
            setState(() {
               _currentIndex = index;
            });
          },
          
          items: [
              BottomNavyBarItem(icon: Icon(Icons.person_outline), title:inside == false ? Text('Profilim') : Text('Giriş Yap \nKayıt Ol'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.fastfood,), title: Text('Menü'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.reorder,), title: Text('Siparişlerim'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.shopping_cart,), title: Text('Sepetim'), activeColor: Colors.white),
          ],
        )
      ),
    );
  }
}


