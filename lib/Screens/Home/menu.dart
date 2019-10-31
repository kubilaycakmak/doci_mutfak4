import 'dart:ui' as prefix0;

import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                                      title: Text(dataProducts[index][i]['name'].toString()),
                                      subtitle: dataProducts[index][i]['isValid'].toString() == 'true' ?
                                      Text(dataProducts[index][i]['description'],maxLines: 2,)
                                       : Container(child: Card(child: Text('Ürün stokta yoktur', style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                                        color: Colors.red, elevation: 10, margin: EdgeInsets.all(5),),),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' '): Text(dataProducts[index][i]['priceWithoutNoDiscount'].toInt().toString() +' TL',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontWeight:
                                                          FontWeight.w400),),
                                          Text('  '),
                                          Text(dataProducts[index][i]["price"].toInt().toString() +' TL',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                          dataProducts[index][i]['isValid'].toString() == 'true' ?
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.black54,
                                                elevation: 0,
                                                titlePadding: EdgeInsets.all(0),
                                                title: Column(
                                                  children: <Widget>[
                                                    CupertinoButton(
                                                      padding: EdgeInsets.all(20),
                                                      color: Colors.transparent,
                                                      child: Text('Detay'),
                                                      onPressed: () {
                                                        Navigator.pop(context, false);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              backgroundColor: Colors.black54,
                                                              title: Text(
                                                                'Adet Giriniz',
                                                                style: TextStyle(color: Colors.white),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              contentTextStyle: TextStyle(
                                                                color: Colors.white
                                                              ),
                                                              contentPadding:
                                                              EdgeInsets.all(0),
                                                              elevation: 0,
                                                              content: Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: 100, right: 100),
                                                                  width: 20,
                                                                  child: TextFormField(
                                                                    cursorColor: Colors.white,
                                                                    keyboardType:
                                                                    TextInputType.number,
                                                                    decoration: InputDecoration(
                                                                      hintText: 'Örn, 5',
                                                                      hintStyle: TextStyle(
                                                                        color: Colors.white
                                                                      ),
                                                                      focusColor: Colors.white,
                                                                      hoverColor: Colors.white,
                                                                      fillColor: Colors.white
                                                                    ),
                                                                  )),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text('Tamam',
                                                                    style: TextStyle(color: Colors.white),),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context, false);
                                                                  },
                                                                )
                                                              ],
                                                            ));
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      color: Colors.transparent,
                                                      child: Text('1 Adet Ekle'),
                                                      onPressed: () {
                                                        Alert(
                                                          type: AlertType.success,
                                                          title: 'Ürün sepete eklendi',
                                                          buttons: [
                                                            DialogButton(
                                                              onPressed: (){
                                                                Navigator.pop(context);
                                                            },
                                                              child: Text('Tamam',style: TextStyle(color: Colors.white),),
                                                            ),
                                                          ],
                                                          context: context,
                                                        ).show();
                                                        dataProducts[index][i]['isValid'].toString() =='true' ?
                                                        setState(() {
                                                          var items = new AddItemtoShopCart(
                                                            id: dataProducts[index][i]["id"],
                                                            name: dataProducts[index][i]["name"],
                                                            price: dataProducts[index][i]["price"],
                                                            itemCount: quantity,
                                                            quantity: quantity,
                                                          );
                                                          listItems.add(items);
                                                        }): setState(() {
                                                          print('stok yok');
                                                        });
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      color: Colors.transparent,
                                                      child: Text('Geri'),
                                                      onPressed: () =>
                                                          Navigator.pop(context, false),
                                                    )
                                                  ],
                                                ),
                                              )) :
                                        print('asd');
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
        ));
  }
}
