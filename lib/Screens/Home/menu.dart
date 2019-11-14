import 'dart:io';

import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Model/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var currentSelected;
List<String> addItem;
bool switches = false;
List<AddItemtoShopCart> listItems = new List();
List<AddItemtoShopCart> getList() {
  return listItems;
}
final GlobalKey expansionTileKey = GlobalKey();
int switchCounter = 0;
double previousOffset;
int maxLines = 2;
int ontapping = 0;
bool isSelected = false; 
var itemOfProducts;
Products products;
AnimationController c ;
bool door = false;
var types;

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);

void _showToast(BuildContext context, String desc) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      shape: CircleBorder(
        side: BorderSide(
          style: BorderStyle.solid
        ),
      ),
      duration: Duration(milliseconds: 500),
      elevation: 0,
      backgroundColor: Colors.black45,
      content: Text(
        desc,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 20,
            fontWeight: FontWeight.w500),
      ),
      behavior: SnackBarBehavior.floating,
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


  Future<List<Types>> _fetchTypes() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      types = items;
      List<Types> listOfTypes = items["types"].map<Types>((json) {
        return Types.fromJson(json);
      }).toList();
      dataProducts = items["products"];
      return listOfTypes;
    } else {
      throw Exception('Failed to get Types');
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Menü'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          child: FutureBuilder<List<Types>>(
          future: _fetchTypes(),
          builder: (BuildContext context, AsyncSnapshot<List<Types>> snapshot) {
            if (!snapshot.hasData)
              return Container(
                  child: Container(child: Center(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 20,),
                      Text('Yükleniyor')
                    ],
                  ),)),
                  alignment: Alignment.center);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].name, style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, color: Colors.lightBlueAccent),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    dense: false,
                    subtitle: FutureBuilder<List<Types>>(
                      future: _fetchTypes(),
                      builder: (BuildContext context, AsyncSnapshot<List<Types>> snapshot2){
                        if (!snapshot.hasData)
                          return Container(
                              child: Column(
                                children: <Widget>[
                                  CircularProgressIndicator()
                                ],
                              ),
                              );
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: dataProducts[index].length,
                            itemBuilder: (BuildContext context, int i){
                                return ListTile(
                                leading: Container(
                                  child: VerticalDivider(
                                  thickness: 3,
                                  endIndent: 0,
                                  color: Colors.lightBlueAccent,
                                ),
                                ),
                                title: Text(dataProducts[index][i]['name'].toString(),),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    currentSelected.toString() == dataProducts[index][i].toString() ?
                                    dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') : Text((dataProducts[index][i]['priceWithoutNoDiscount']).toInt().toString() +' TL',
                                      style: TextStyle(
                                          fontSize: 13,
                                          decoration: TextDecoration
                                              .lineThrough,
                                          fontWeight:
                                          FontWeight.w400),) : dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') :  Text(dataProducts[index][i]['priceWithoutNoDiscount'].toInt().toString() +' TL',style: TextStyle(
                                        fontSize: 13,
                                        decoration: TextDecoration
                                            .lineThrough,
                                        fontWeight:
                                        FontWeight.w400),),
                                    Text('  '),
                                    currentSelected.toString() == dataProducts[index][i].toString() ?
                                    Text((dataProducts[index][i]["price"]).toInt().toString() +' TL') : Text(dataProducts[index][i]["price"].toInt().toString() +' TL'),
                                    SizedBox(width: 20,),
                                    dataProducts[index][i]['description'].toString() != '' ? 
                                    Text('Açıklama için tıklayınız', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),) : Text(''),
                                  ],
                                ),
                                onTap: (){
                                  dataProducts[index][i]['description'].toString() == '' ? null : Alert(
                                    context: context,
                                    title: dataProducts[index][i]['name'].toString(),
                                    desc: dataProducts[index][i]['description'].toString(),
                                    style: AlertStyle(
                                      titleStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                      ),
                                      descStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300
                                      ),
                                      isCloseButton: false,
                                    ),
                                    buttons: [
                                      DialogButton(
                                        child: Text('Kapat', style: TextStyle(color: Colors.white),),
                                        onPressed: ()=> Navigator.pop(context),
                                      )
                                    ]
                                  ).show();
                                },
                                trailing: InkWell(
                                      child: dataProducts[index][i]['valid'].toString() == 'true' ? Icon(Icons.add_circle_outline) : Text(''),
                                      onTap: (){
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(milliseconds: 700), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              backgroundColor: Colors.black45,
                                              shape: CircleBorder(
                                              ),
                                              title: Column(
                                                children: <Widget>[
                                                  Icon(Icons.check, color: Colors.green, size: 70,),
                                                  SizedBox(height: 5,),
                                                  Text('Eklendi', style: TextStyle(color: Colors.white),)
                                                ],
                                              ),
                                            );
                                          });
                                        if(this.mounted) {
                                            var currentItemId = dataProducts[index][i]['id'];
                                            switches = false;
                                            if (listItems == null) {
                                              var items = new AddItemtoShopCart(
                                                id: dataProducts[index][i]["id"],
                                                name: dataProducts[index][i]["name"],
                                                price: dataProducts[index][i]["price"],
                                                itemCount: 1,
                                              );
                                              listItems.add(items);
                                            } else {
                                              bool ifExist = false;
                                              for (var k = 0; k <
                                                  listItems.length; k++) {
                                                if (currentItemId ==
                                                    listItems[k].id) {
                                                  ifExist = true;
                                                }
                                              }
                                              if (ifExist) {
                                                for (var j = 0; j <
                                                    listItems.length; j++) {
                                                  if (listItems[j].id ==
                                                      currentItemId) {
                                                    listItems[j]
                                                        .itemCount++;
                                                  }
                                                }
                                              } else {
                                                var items = new AddItemtoShopCart( // var items = new AddItemtoShopCart(
                                                  id: dataProducts[index][i]["id"],
                                                  name: dataProducts[index][i]["name"],
                                                  price: dataProducts[index][i]["price"],
                                                  itemCount: 1,
                                                );
                                                listItems.add(items);
                                              }
                                            }
                                          }
                                        },
                                      ),
                              );
                            },
                          );
                      },
                    ),
                );
          },
        );
          }),
        onRefresh: _refreshController,
        backgroundColor: Colors.lightBlueAccent,
        color: Colors.white,
        ));
  }

  Future<void> _refreshController() async
  {
    if(this.mounted) {
      setState(() {
      });
    }
  }
}
