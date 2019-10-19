import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Screens/Home/shoppingCart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
List<String> addItem;
List<AddItemtoShopCart> listItems = new List();
void _showToast(BuildContext context, String desc) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(desc),
        action: SnackBarAction(
            label: 'Gizle', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> with TickerProviderStateMixin{
  var currentProduct;
  List dataProducts;
  List dataTypes;
  List<Product> product = new List<Product>();
  TabController tabController;
  int _counter = 1; 
  
  String url = 'http://68.183.222.16:8080/api/dociproduct/all';

    @override
  void initState() { 
    this.makeRequest();
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
      if(dataTypes[index]['name'] == null){
        return Container(
          child: Center(
            child: CircularProgressIndicator()
          ),
        );
      }else{
        return ExpansionTile(
          title: Text(dataTypes[index]['name'], 
          style: 
                TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.w300),),
          children: <Widget>[
            
            ListView.builder(
              dragStartBehavior: DragStartBehavior.down,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              reverse: false,
              itemCount: dataProducts[index] == null ? 0 : dataProducts[index].length,
              itemBuilder: (context, i){
                double _countPrice = dataProducts[index][i]['price'];
                  return ListTile(
                    dense: true,
                    enabled: true,
                    isThreeLine: false,
                    title: Text(dataProducts[index][i]['name']),
                    subtitle: Text(dataProducts[index][i]['description']),
                    trailing: Text(dataProducts[index][i]['price'].toString() + ' TL'),
                    leading: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.add_box,),
                      onPressed: null,
                    ),
                    onTap: (){
                        return Alert(
                          buttons: [
                            DialogButton(
                              child: Text('+'),
                              onPressed: (){
                                setState(() {
                                 _counter++; 
                                 _countPrice += (dataProducts[index][i]['price']); 
                                 print(_counter);
                                 print(_countPrice);
                                });
                              },
                              height: 30,
                              width: 30,
                              color: Colors.deepOrange,
                            ),
                            DialogButton(
                              child: Text('-'),
                              onPressed: (){
                                setState(() {
                                  if(_counter!=1){
                                    _counter--; 
                                    _countPrice -= (dataProducts[index][i]['price']); 
                                  }else{
                                  _counter = 1;
                                  }
                                  print(_counter);
                                  print(_countPrice);
                                });
                              },
                              height: 30,
                              width: 30,
                              color: Colors.deepOrange,
                            ),
                            DialogButton(
                              child: Text("$_counter" + ' Adet Ekle', style: TextStyle(color: Colors.white),),
                              onPressed: (){
                                Navigator.of(context).pop();
                                _showToast(context, "Urun Sepete Eklendi!");
                                setState(() {
                                  var items = new AddItemtoShopCart(
                                  id: dataProducts[index][i]["id"],
                                  name: dataProducts[index][i]["name"],
                                  price: dataProducts[index][i]["price"]
                                );
                                listItems.add(items);
                                });
                                print(listItems[index].name);
                                
                              },
                              color: Colors.deepOrange,
                            ),
                              ],
                          context:context, 
                          title: dataProducts[index][i]['name'],
                          desc: dataProducts[index][i]['description'],
                          content: Text(_countPrice.toString() + ' TL')).show(); 
                          }
                        );
                      },
                  )
            ],
                );
              }
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
        Text('DETAIL PAGE', textAlign: TextAlign.center,),
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

class AddItemtoShopCart{
  int id;
  String name;
  double price;

  AddItemtoShopCart({@required this.id, @required this.name, @required this.price});
}

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    double _count = 0;

      setState(() {
        for (var item in listItems) {
          _count = _count + item.price;
        }
      });

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(listItems[index].name),
              onLongPress: (){
                _showToast(context, "Urun Sepetten Cikartildi!");
                setState(() {
                  listItems.removeAt(index);
                });
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text("Tutar: "),
                  subtitle: Text(_count.toString() + " TL"),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  color: Colors.lightBlueAccent,
                  onPressed: (){},
                  child: Text('Siparisi ver!',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}

