import 'dart:async';
import 'dart:convert';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:doci_mutfak4/Screens/Home/shop_cart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'last_orders.dart';
import 'menu.dart';

int _currentIndex = 1;
class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var username;
  var password;
  var keyShared;
  bool switcha;
  Timer timer;
  var user;

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
  
  getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
    keyShared = prefs.getString('LastKey');
    if(key != ''){
      setState(() {
        postRequesAuto(username, password);
        postItselfAuto(keyShared);
        print(keyShared);
      });
    }
    else{
      print('key yerinde');
    }
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
    timer = Timer.periodic(Duration(hours: 3), (Timer t)=> getKey());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Profile(),
      Menu(),
      LastOrders(),
      ShoppingCart(),
    ];
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
          child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          height: SizeConfig.blockSizeVertical*9,
          child: BottomNavyBar(
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
              BottomNavyBarItem(icon: Icon(Icons.check_box,), title: Text('Siparişlerim'), activeColor: Colors.white),
              BottomNavyBarItem(icon: Icon(Icons.shopping_cart,), title: Text('Sepetim'), activeColor: Colors.white),
          ],
        ),
        )
      ),
    );
  }
}


