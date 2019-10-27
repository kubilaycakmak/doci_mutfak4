import 'package:bottom_navy_bar/bottom_navy_bar.dart';
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
          //indicatorColor: Colors.white,
          //reverse: true,
          //inactiveStripColor: Colors.transparent,
          //currentIndex:  _currentIndex,
          /*initialIndex: _currentIndex,
          animationCurve: Curves.ease,
          color: Colors.white,
          buttonBackgroundColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent,*/
          selectedIndex: _currentIndex,
          showElevation: false,
          backgroundColor: Colors.lightBlueAccent,
          onItemSelected: (index){
            setState(() {
               _currentIndex = index;
            });
          },
          
          items: [
              //TitledNavigationBarItem(title: inside == false ? 'Profilim' : 'Giriş Yap\n & Kayıt Ol', icon: Icons.person_outline),
              //TitledNavigationBarItem(title: 'Menü', icon: Icons.fastfood),
              //TitledNavigationBarItem(title: 'Siparişlerim', icon: Icons.info_outline),
              //TitledNavigationBarItem(title: 'Sepetim', icon: Icons.shopping_cart),
              BottomNavyBarItem(icon: Icon(Icons.person_outline), title:inside == false ? Text('Profilim') : Text('Giriş Yap \nKayıt Ol'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.fastfood,), title: Text('Menü'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.info_outline,), title: Text('Siparişlerim'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.shopping_cart,), title: Text('Sepetim'), activeColor: Colors.white),
          ],
        )
      ),
    );
  }
}


