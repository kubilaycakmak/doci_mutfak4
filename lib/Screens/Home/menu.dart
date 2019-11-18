import 'dart:ui' as prefix0;

import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Model/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
List headerList;
var types;

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);


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
      headerList = items['types'];
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
    print(headerList);
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Menü'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
          actions: <Widget>[
            // Badge(
            // position: BadgePosition.topLeft(top: 3, left: 5),
            // badgeContent: Text('${listItems.length.toString()}'),
            // child: IconButton(
            //   icon: Icon(Icons.shopping_cart, size: 40,),
            //   onPressed: () {},
            // ),
            // )
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
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
                    isThreeLine: true,
                    onTap: (){
                      print('asd');
                    },
                    title: 
                    snapshot.data[index].priority <= 0 ?
                    Text(' KAMPANYALI ÜRÜNLER ', style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, color: Colors.deepOrangeAccent),):
                    Text(snapshot.data[index].name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, color: Colors.lightBlueAccent),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                                leading: 
                                snapshot.data[index].priority <= 0 ?
                                Container(
                                  child: VerticalDivider(
                                  thickness: 5,
                                  endIndent: 0,
                                  color: Colors.orange,
                                ),
                                )
                                :
                                Container(
                                  child: VerticalDivider(
                                  thickness: 5,
                                  endIndent: 0,
                                  color: Colors.lightBlueAccent,
                                ),
                                )
                                ,
                                title: Text(dataProducts[index][i]['name'].toString(),),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: 
                                  
                                  dataProducts[index][i]['valid'].toString() == 'true' ?
                                  <Widget>[
                                    currentSelected.toString() == dataProducts[index][i].toString() ?
                                    dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') : Card(
                                      shape: CircleBorder(),
                                      child: Text((dataProducts[index][i]['priceWithoutNoDiscount']).toInt().toString() +' TL',
                                      style: TextStyle(
                                          fontSize: 14,
                                          decoration: TextDecoration
                                              .lineThrough,
                                          fontWeight:
                                          FontWeight.w400),) ,
                                    ) : dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') :  Card(
                                      elevation: 3,
                                      color: Colors.redAccent,
                                      child: Text('  '+(dataProducts[index][i]['priceWithoutNoDiscount']).toInt().toString() +' TL  ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          decoration: TextDecoration
                                              .lineThrough,
                                          fontWeight:
                                          FontWeight.w400),) ,
                                    ),
                                    currentSelected.toString() == dataProducts[index][i].toString() ?
                                    Card(
                                      elevation: 3,
                                      color: Colors.green,
                                      child: Text('  '+(dataProducts[index][i]['price']).toInt().toString() +' TL  ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w400),) ,
                                    ) : Card(
                                      elevation: 3,
                                      color: Colors.green,
                                      child: Text('  '+(dataProducts[index][i]['price']).toInt().toString() +' TL  ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w400),) ,
                                    ),
                                    SizedBox(width: 5,),
                                    dataProducts[index][i]['description'].toString() != '' ? 
                                    Text('Açıklama için tıkla', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),) : Text(''),
                                  ] : <Widget>[
                                    Card(child: Text('Bu ürün stokta yok  ', style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,),
                                            color: Colors.red, elevation: 3, ),

                                  ],
                                ),
                                onTap: (){
                                  dataProducts[index][i]['description'].toString() == '' ? null : Alert(
                                    context: context,
                                    title: dataProducts[index][i]['name'].toString(),
                                    desc: dataProducts[index][i]['description'].toString(),
                                    style: AlertStyle(
                                      animationDuration: Duration(milliseconds: 500),
                                      animationType: AnimationType.grow,
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
                                      child: dataProducts[index][i]['valid'].toString() == 'true' ? Container(padding: EdgeInsets.all(10),child: 
                                      snapshot.data[index].priority <= 0 ? 
                                      Icon(FontAwesomeIcons.plusSquare, color: Colors.deepOrangeAccent,size: 30,)
                                      :
                                      Icon(FontAwesomeIcons.plusSquare, color: Colors.lightBlueAccent,size: 30,),)
                                       : Text(''),
                                      onTap: (){
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(milliseconds: 700), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return BackdropFilter(
                                              filter: prefix0.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                              child: AlertDialog(
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
              },
          ),),
        );
  }
}
