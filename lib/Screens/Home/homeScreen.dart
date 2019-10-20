import 'package:doci_mutfak4/Screens/Home/info.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
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
      homeScreen2()
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
            TitledNavigationBarItem(title: 'Profilim', icon: Icons.person_outline),
        ],
      )
    );
  }
}

class homeScreen2 extends StatelessWidget {
  const homeScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0),
          child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.lightBlueAccent,
            ),
            Container(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.black38,
                child: Text('A')
              ),
              color: Colors.black45,
            ),
            Center(
              child: Column(
                children: <Widget>[
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}