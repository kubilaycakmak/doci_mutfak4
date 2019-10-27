import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<String> addItem;
List<AddItemtoShopCart> listItems = new List();
List<AddItemtoShopCart> getList(){
  return listItems;
}
int _counter = 1;
int currentType;
int currentProduct;

Types currentTypes;
Products currentProducts;

void _showToast(BuildContext context, String desc) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.lightBlueAccent,
      content: Text(desc, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.w500),),
    ),
  );
}


class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

_MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu>{
  List dataProducts;
  var quantity = 1 ;
  TabController tabController;
  String url = 'http://68.183.222.16:8080/api/dociproduct/all';

  @override
  void initState() { 
    super.initState();
    this.makeRequest();
  }

  Future<String> makeRequest() async{
    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": 'application/json'
    });
    if(response.statusCode == 200){
        final items = json.decode(response.body);
        dataProducts = items["products"];
    }
  }

  Future<List<Types>> _fetchTypes() async{
    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": 'application/json'
    });
    if(response.statusCode == 200){
      final items = json.decode(response.body);
      List<Types> listOfTypes = items["types"].map<Types>((json){
        return Types.fromJson(json);
      }).toList();
      return listOfTypes;
    }else{
      throw Exception('Failed to get Types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menü'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        ),
        body: FutureBuilder<List<Types>>(
          future: _fetchTypes(),
          builder: (BuildContext context, AsyncSnapshot<List<Types>> snapshot){
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return ExpansionTile(
                  title: Text(snapshot.data[index].name),
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: false,
                      itemCount: dataProducts[index] == null ? 0 : dataProducts[index].length,
                      itemBuilder: (context, i){
                        return ListTile(
                          title: Text(dataProducts[index][i]['name']),
                          subtitle: Text(dataProducts[index][i]['description']),
                          trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                              dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') :
                              Text(dataProducts[index][i]['priceWithoutNoDiscount'].toInt().toString() + ' TL', style: TextStyle(fontSize: 16,decoration: TextDecoration.lineThrough ,fontWeight: FontWeight.w400),),
                              Text('  '),
                              Text(dataProducts[index][i]['price'].toInt().toString() + ' TL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                            ],
                          ),
                          leading: IconButton(
                            icon: Icon(Icons.add_circle_outline, size: 29,),
                            onPressed: (){
                              _showToast(context, "Ürün sepete eklenmiştir!");
                                  setState(() {
                                    var items = new AddItemtoShopCart(
                                    id: dataProducts[index][i]["id"],
                                    name: dataProducts[index][i]["name"],
                                    price: dataProducts[index][i]["price"],
                                    itemCount: 1,
                                  );
                                    listItems.add(items);
                                  });
                                },
                              ),
                            onTap: (){
                              return showDialog(
                                context: context,
                                builder: (context)=>AlertDialog(
                                  title: Text(dataProducts[index][i]['name'], textAlign: TextAlign.center,),
                                    content: ListTile(
                                      title: Text(dataProducts[index][i]['description'], style: TextStyle(fontSize: 13),),
                                      subtitle: Text(dataProducts[index][i]['price'].toInt().toString() + ' TL', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                                    ),
                                    elevation: 20,
                                  actions: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                             _counter++; 
                                             print(_counter);
                                            });
                                          },
                                          child: Icon(Icons.add),
                                        ),
                                        FlatButton(
                                          onPressed: null,
                                          child: Text(_counter.toString() + 'Sepete Ekle'),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            setState(() {
                                             if(_counter == 1) _counter=1;
                                             else _counter--;
                                             print(_counter);
                                            });
                                          },
                                          child: Icon(Icons.remove),
                                        )
                                      ],
                                )
                              );
                            },
                        );
                      },
                    )
                  ],
                );
              },
            );
          },
        )
      );
    }
  }
