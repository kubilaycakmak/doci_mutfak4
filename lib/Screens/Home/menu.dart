import 'package:doci_mutfak4/Model/products.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

List<String> addItem;
List<AddItemtoShopCart> listItems = new List();
List<Types> types = new List();
int _counter = 1; 
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
  var dataProduct;
  var dataType;
  List dataTypes;
  List<Product> product = new List<Product>();
  TabController tabController;
   var _extractData;
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
      _extractData = json.decode(response.body);
    });
      dataTypes = _extractData["types"];
      dataProducts = _extractData["products"];

      for (var i = 0; i < dataTypes.length; i++) {
        dataType = new Types(
          id: dataTypes[i]['id'],
          name: dataTypes[i]['name']
        );
        types.add(dataType);
      }
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
          title: Text(types[index].name, 
          style: 
                TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.w300),),
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(2),
              dragStartBehavior: DragStartBehavior.down,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              reverse: false,
              itemCount: dataProducts[index] == null ? 0 : dataProducts[index].length,
              itemBuilder: (context, i){
                double _countPrice = dataProducts[index][i]['price'];
                void _increase(){
                  setState(() {
                    _counter++;
                    _countPrice += dataProducts[index][i]['price'];
                    print(_counter);
                    print(_countPrice);
                  });
                }
                void _decrease(){
                  setState(() {
                    if(_counter!=1){
                      _countPrice -= (dataProducts[index][i]['price']); 
                      _counter--; 
                      
                    }else{
                    _counter = 1;
                    }
                    print(_counter);
                    print(_countPrice);
                  });
                }
                    return ListTile(
                      title: Text(dataProducts[index][i]['name']),
                      subtitle: Text(dataProducts[index][i]['description']),
                      trailing: Text(dataProducts[index][i]['price'].toString() + ' TL'),
                      leading: IconButton(
                        padding: EdgeInsets.all(00),
                        icon: Icon(Icons.add_shopping_cart, size: 45,),
                        onPressed: (){
                          _showToast(context, "Urun Sepete Eklendi!");
                                  setState(() {
                                    var items = new AddItemtoShopCart(
                                    id: dataProducts[index][i]["id"],
                                    name: dataProducts[index][i]["name"],
                                    price: dataProducts[index][i]["price"],
                                    itemCount: 1,
                                  );
                                  listItems.add(items);
                                  });
                                  print(listItems[index].name);
                        },
                      ),
                      onTap: (){
                            _counter = 1;
                            return Alert(
                              style: alertStyle,
                              buttons: [
                                DialogButton(
                                  child: Text('+', 
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                  ),),
                                  onPressed: _increase,
                                  color: Colors.lightBlueAccent,
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
                                      price: dataProducts[index][i]["price"],
                                      itemCount: _counter
                                    );
                                    listItems.add(items);
                                    });
                                    print(listItems[index].itemCount);
                                  },
                                  color: Colors.lightBlueAccent,
                                ),
                                DialogButton(
                                  child: Text('-',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white
                                  ),),
                                  onPressed: _decrease,
                                  color: Colors.lightBlueAccent,
                                ),
                                  ],
                              context:context, 
                              title: dataProducts[index][i]['name'],
                              desc: dataProducts[index][i]['description'],
                              content: Text(_countPrice.toString() + ' TL'),
                              type: AlertType.none,
                              ).show(); 
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
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Mutfak'),
          centerTitle: true,
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            listView,
            Text('DETAIL PAGE', textAlign: TextAlign.center,),
          ],
        ),
        ),
      );
      }
    }
    class AddItemtoShopCart{
      int id;
      String name;
      double price;
      int itemCount;

      AddItemtoShopCart({
        @required this.id, 
        @required this.name, 
        @required this.price,
        this.itemCount
        });
    }

    class Products{
      int id;
      String name;
      String desc;
      double price;
      bool isValid;
      String created;

      Products({
        this.id,
        this.name,
        this.desc,
        this.price,
        this.isValid,
        this.created
      });
    }

    class Types{
      int id;
      String name;

      Types({
        this.id,
        this.name
      });
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
              _count = _count + item.price * item.itemCount;
            }
          });

        return Scaffold(
          appBar: AppBar(
            title: Text('Sepetim'),
            centerTitle: true,
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: Container(
            child: ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (context, index){
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(listItems[index].itemCount.toString() + ' x ' + listItems[index].name),
                      subtitle: Text('Urunu sepetten cikartmak icin basili tutunuz!'),
                      trailing: Text(((listItems[index].price)*(listItems[index].itemCount)).toInt().toString() + ' TL'),
                      onLongPress: (){
                        _showToast(context, "Urun Sepetten Cikartildi!");
                        setState(() {
                          listItems.removeAt(index);
                        });
                      },
                    ),
                    ButtonBar(
                      children: <Widget>[
                        RaisedButton(
                          child: Text("+"),
                          onPressed: (){
                            setState(() {
                             listItems[index].itemCount++; 
                            });
                          },
                    ),
                        RaisedButton(
                          child: Text("-"),
                           onPressed: (){
                            setState(() {
                             if (listItems[index].itemCount != 1) {
                               listItems[index].itemCount--; 
                             }
                            });
                          },
                        ),
                      ],
                    )
                  ],
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
var alertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: true,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.lightBlueAccent,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.black,
      ),
);
