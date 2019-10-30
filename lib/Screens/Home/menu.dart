import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

var currentSelected;
List<String> addItem;
bool switches = false;
List<AddItemtoShopCart> listItems = new List();
List<AddItemtoShopCart> getList() {
  return listItems;
}
int switchCounter = 0;
int _counter = 1;
var itemOfProducts;
Products products;

void _showToast(BuildContext context, String desc) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.lightBlueAccent,
      content: Text(
        desc,
        style: TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 20,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  List dataProducts;
  var quantity = 1;
  TabController tabController;
  String url = 'http://68.183.222.16:8080/api/dociproduct/all';

  // ignore: missing_return
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      dataProducts = items["products"];
    }
  }

  Future<List<Types>> _fetchTypes() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<Types> listOfTypes = items["types"].map<Types>((json) {
        return Types.fromJson(json);
      }).toList();
      makeRequest();
      return listOfTypes;
    } else {
      throw Exception('Failed to get Types');
    }
  }

  Future<String> _fetchProduct() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      final productItems = items['products'];
      List listOfProducts = productItems;
      return listOfProducts.toString();
    } else {
      throw Exception('Failed to get Types');
    }
  }
  @override
  // ignore: must_call_super
  void initState() {
    this.makeRequest();
  }
  @override
  Widget build(BuildContext context) {
    _fetchProduct();
    return Scaffold(
        appBar: AppBar(
          title: Text('Menü'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
        ),
        body: FutureBuilder<List<Types>>(
          future: _fetchTypes(),
          builder: (BuildContext context, AsyncSnapshot<List<Types>> snapshot) {
            if (!snapshot.hasData)
              return Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(snapshot.data[index].name),
                    children: <Widget>[
                      FutureBuilder<String>(
                          future: _fetchProduct(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshotProducts) {
                            if (!snapshotProducts.hasData)
                              return Container(
                                  child: CircularProgressIndicator(),
                                  alignment: Alignment.center);
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: dataProducts[index].length,
                              itemBuilder: (BuildContext context, int i) {
                                return Card(
                                  child: ListTile(
                                    // ignore: unrelated_type_equality_checks
                                      title: Text(dataProducts[index][i]['name'].toString()),
                                      subtitle:
                                      dataProducts[index][i]['isValid'].toString() == 'true' ?
                                      switches == false ? Text(dataProducts[index][i]['description'])
                                          :
                                      currentSelected.toString() == dataProducts[index][i].toString()
                                          ?
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          InkWell(
                                            child: Icon(Icons.add),
                                            onTap: () {
                                              setState(() {
                                                _counter++;
                                              });
                                            },
                                          ),
                                          MaterialButton(
                                            elevation: 0,
                                            height: 10,
                                            minWidth: 20,
                                            child: Text(_counter.toString() + ' Adet', style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white
                                            ),),
                                            onPressed: () {
                                              _showToast(context,
                                                  "$_counter adet ürün sepete eklenmiştir!");
                                              setState(() {
                                                switches = false;
                                                var items = new AddItemtoShopCart(
                                                  id: dataProducts[index][i]["id"],
                                                  name: dataProducts[index][i]["name"],
                                                  price: dataProducts[index][i]["price"],
                                                  itemCount: _counter,
                                                );
                                                listItems.add(items);
                                              });
                                            },
                                            color: Colors.lightBlueAccent,
                                          ),

                                          InkWell(
                                            child: Icon(Icons.remove),
                                            onTap: () {
                                              setState(() {
                                                if (_counter == 1)
                                                  _counter = 1;
                                                else
                                                  _counter--;
                                                print(_counter);
                                              });
                                            },
                                          )
                                        ],
                                      ) : Text(dataProducts[index][i]['description']) : Card(child: Text('Ürün stokta yoktur', style: TextStyle(color: Colors.white),), color: Colors.red, elevation: 0, margin: EdgeInsets.all(20),),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') : Text(dataProducts[index][i]['priceWithoutNoDiscount'].toInt().toString() + ' TL',
                                            style: TextStyle(
                                                fontSize: 16,
                                                decoration: TextDecoration
                                                    .lineThrough,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text('  '),
                                          Text(dataProducts[index][i]["price"].toInt().toString()+ ' TL',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      leading: IconButton(
                                        color: Colors.lightBlueAccent,
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: 29,
                                        ),
                                        onPressed: () {
                                          dataProducts[index][i]['isValid'].toString() == 'true' ?
                                          _showToast(
                                              context, "Ürün sepete eklenmiştir!") :
                                          _showToast(
                                              context, "Hata, Ürün stoklarımızda bulunamadı!");

                                          dataProducts[index][i]['isValid'].toString() == 'true' ?
                                          setState(() {
                                            var items = new AddItemtoShopCart(
                                              id: dataProducts[index][i]["id"],
                                              name: dataProducts[index][i]["name"],
                                              price: dataProducts[index][i]["price"],
                                              itemCount: quantity,
                                              quantity: quantity,
                                            );
                                            listItems.add(items);
                                          }) :
                                          setState(() {
                                            print('stok yok');
                                          });
                                        },
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _counter = 1;
                                          switchCounter++;
                                          currentSelected = dataProducts[index][i];
                                          switches = true;
//                                      print(currentSelected);
//                                      if(switchCounter == 1){
//                                        print('asd');
//                                        switches = false;
//                                        switchCounter = 1;
//                                      }
//                                      else if(switchCounter == 2){
//
//                                        switchCounter = 0;
//                                      }
                                        });
                                      }),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                );
          },
        );
      },
    )
    );

  }
}
