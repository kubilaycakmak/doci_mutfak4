import 'package:doci_mutfak4/Screens/Home/info.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:doci_mutfak4/Screens/Home/shop_cart.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/material.dart';
import 'menu.dart';

int _currentIndex = 3;
class HomeScreen extends StatefulWidget {
  
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Menu(),
      ShoppingCart(),
      Info(),
      Profile()
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: TitledBottomNavigationBar(
        inactiveStripColor: Colors.transparent,
        
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {

             _currentIndex = index;
          });
        },
        items: [
            TitledNavigationBarItem(title: 'Mutfak', icon: Icons.fastfood),
            TitledNavigationBarItem(title: 'Sepetim', icon: Icons.shopping_cart),
            TitledNavigationBarItem(title: 'Hakkimizda\n & Iletisim', icon: Icons.info_outline),
            TitledNavigationBarItem(title: inside == false ? 'Profilim' : 'Giris Yap\n & Kayit Ol', icon: Icons.person_outline),
        ],
      )
    );
  }
}

