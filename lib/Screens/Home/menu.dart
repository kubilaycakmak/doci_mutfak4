import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Screens/Home/shoppingCart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> with TickerProviderStateMixin{
  List dataProducts;
  List dataTypes;
  List<Product> product = new List<Product>();
  TabController tabController;
  String url = 'http://68.183.222.16:8080/api/dociproduct/all';

  int _counter = 1; 

    @override
  void initState() { 
    this.makeRequest();
  }
  void add(){
          setState(() {
        _counter++;
      });
    }

    void minus(){
      setState(() {
        if (_counter != 1) {
          _counter--;
          print('$_counter');
        }
      });
    }

  Future<String> makeRequest() async{
    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": 'application/json'
    });
    setState(() {
      var extractData = json.decode(response.body);
      dataTypes = extractData["types"];
      dataProducts = extractData["products"];
    });
  }

      @override
      Widget build(BuildContext context) {
        tabController = new TabController(length: 2, vsync: this);
        var tabBarItem = new TabBar(
          tabs: <Widget>[
            Tab(
              child: Text('Menuler'),
            ),
            Tab(
              child: Text('Detaylar'),
            )
          ],
          controller: tabController,
          indicatorColor: Colors.white,
        );
        
  var listView = ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    reverse: false,
    itemCount: dataTypes == null ? 0 : dataTypes.length,
    itemBuilder: (BuildContext context, int index){
      return ListTile(
        contentPadding: EdgeInsets.all(10),
        enabled: false,
        title: Text(dataTypes[index]['name'], style: 
        TextStyle(
          fontSize: 15, 
          fontWeight: FontWeight.w300),
          textScaleFactor: 1.3,),
        subtitle: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 5),
          itemCount: dataProducts[index] == null ? 0 : dataProducts[index].length,
          itemBuilder: (context, i){
                return ListTile(
                  title: Text(dataProducts[index][i]['name']),
                  subtitle: Text(dataProducts[index][i]['description']),
                  trailing: Text(dataProducts[index][i]['price'].toString() + ' TL'),
                  leading: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.add_box,),
                    onPressed: null,
                  ),
                  onTap: (){
                    _counter = 1;
                       return Alert(
                        context:context, 
                        title: dataProducts[index][i]['name'],
                        desc: dataProducts[index][i]['description'],
                        content: Text(dataProducts[index][i]['price'].toString() + ' TL'),
                        buttons: [
                          DialogButton(
                            child: Text('+'),
                            onPressed: add,
                            height: 30,
                            width: 30,
                            color: Colors.deepOrange,
                          ),
                          DialogButton(
                            child: Text('$_counter' + ' Adet Ekle'),
                            onPressed: null,
                            color: Colors.deepOrange,
                          ),
                          DialogButton(
                            child: Text('-'),
                            onPressed: minus,
                            height: 30,
                            width: 30,
                            color: Colors.deepOrange,
                          ),
                        ]
                      ).show(); 
                    }
                    );
                  },
                )
                
                );
          },
      );
  return DefaultTabController(
    length: 2,
    child: Scaffold(
    appBar: AppBar(
      bottom: tabBarItem,
      backgroundColor: Colors.deepOrange,
      title: Text('Doci Mutfak'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
      ),
    ),
    body: TabBarView(
      controller: tabController,
      children: <Widget>[
        listView,
        Text('asd')
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCart()),
      ),
      child: Icon(Icons.shopping_basket),
      backgroundColor: Colors.deepOrange,
    ),
    ),
  );
  }
}


class DetailPage extends StatefulWidget {
  DetailPage({Key key}) : super(key: key);

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Urun Detayi'),
      ),
      body: Container(
      ),
    );
  }
}

