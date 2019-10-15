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
    var backgroundImage = new AssetImage('assets/images/yemek.jpg');
    var image = new Image(image: backgroundImage,fit: BoxFit.cover);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){},),
          IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white,), onPressed: (){},),
        ],
        backgroundColor: Colors.deepOrange,
        title: Text('Doci Bosnak'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/splash'),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0),
          child: ListView(
          children: <Widget>[
            Image(
              image: AssetImage(
                'assets/images/logo.png'
              ),
              fit: BoxFit.fitHeight,
            ),

            InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, '/menu'),
              child: ListTile(
                title: Text('Menu & Siparis',
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w300,
                  shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.black,
                    offset: Offset(5.0, 5.0)
                  ),
                ]),textScaleFactor: 1.8),
              ),
            ),
            InkWell(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(
                builder: (context) => ShoppingCart()),
              ),
              child: ListTile(
                title: Text('Sepetim', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300, shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.black,
                    offset: Offset(5.0, 5.0)
                  )
                ]),textScaleFactor: 1.8),
              ),
            ),
            InkWell(
              onTap: ()=> Navigator.pushReplacementNamed(context, '/info'),
              child: ListTile(
                title: Text('Hakkimizda', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300, shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.black,
                    offset: Offset(5.0, 5.0)
                  )
                ]),textScaleFactor: 1.8),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, '/contact'),
              child: ListTile(
                title: Text('Iletisim & ulasim', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300, shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.black,
                    offset: Offset(5.0, 5.0)
                  )
                ]),textScaleFactor: 1.8),
              ),
            ),
                  
          ],
        ),
        decoration: BoxDecoration(
              color: Colors.black,
            image: DecorationImage(
              image: backgroundImage,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop)
            )
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.deepOrange,
          primaryColor: Colors.deepOrange
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