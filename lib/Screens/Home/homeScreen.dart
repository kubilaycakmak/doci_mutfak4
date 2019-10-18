import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/shoppingCart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){},),
          IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white,), onPressed: (){},),
        ],
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Doci Bosnak'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/splash'),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
          child: ListView(
          children: <Widget>[
            Image(
              image: AssetImage(
                'assets/images/logo.png'
              ),
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, '/menu'),
              child: ListTile(
                title: Text('Menu & Siparis',
                style: TextStyle(
                  color: Colors.black54, 
                  fontWeight: FontWeight.w300,
                  shadows: [
                  Shadow(
                    blurRadius: 70,
                    color: Colors.black54,
                  ),
                ]),textScaleFactor: 1.8),
              ),
            ),
            InkWell(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(
                builder: (context) => ShoppingCart()),
              ),
              child: ListTile(
                title: Text('Sepetim', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w300, shadows: [
                  Shadow(
                    blurRadius: 70,
                    color: Colors.black54,
                  )
                ]),textScaleFactor: 1.8),
              ),
            ),
            InkWell(
              onTap: ()=> Navigator.pushReplacementNamed(context, '/info'),
              child: ListTile(
                title: Text('Hakkimizda', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w300, shadows: [
                  Shadow(
                    blurRadius: 70,
                    color: Colors.black54,
                  )
                ]),textScaleFactor: 1.8),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, '/contact'),
              child: ListTile(
                title: Text('Iletisim & ulasim', style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w300, shadows: [
                  Shadow(
                    blurRadius: 70,
                    color: Colors.black54,
                  )
                ]),textScaleFactor: 1.8),
              ),
            ),
                  
          ],
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.lightBlueAccent,
          primaryColor: Colors.lightBlueAccent
        ),
        child: BottomNavigationBar(
        currentIndex: _cIndex,
        
        type: BottomNavigationBarType.shifting ,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white,),
            title: new Text('Giris Yap / Yeni Uye')

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white,),
            title: new Text('Ayarlar')
          ),
        ],
        onTap: (index){
            _incrementTab(index);
            if(index == 0){
              Navigator.pushReplacementNamed(context, '/login');
            }else{
              Navigator.pushReplacementNamed(context, '/register');
            }
        },
        )),
    );
  }
}