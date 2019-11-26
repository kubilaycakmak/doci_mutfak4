import 'dart:ui' as prefix0;
import 'package:badges/badges.dart';
import 'package:doci_mutfak4/Connection/api.dart';
import 'package:doci_mutfak4/Connection/api_calls.dart';
import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Model/types.dart';
import 'package:doci_mutfak4/Screens/Profile/profile.dart';
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

var backgroundImage = new AssetImage('assets/images/logo.png');
var image = new Image(image: backgroundImage);
Timer timer;

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu>{
  List type;
  List dataProducts;
  var quantity = 1;
  TabController tabController;
  var response;

  Future<List<Types>> _fetchTypes() async{
    if(response==null){
      response = await http.get(Uri.encodeFull(menuUrl), headers: {"Accept": 'application/json'});
    }
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
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
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "btnshop",
          elevation: 0,
          backgroundColor: Colors.deepOrangeAccent,
          label: Badge(
            animationType: BadgeAnimationType.scale,
            badgeColor: Colors.white,
            elevation: 4,
            badgeContent: Text(listItems.length.toString()),
            child: Icon(FontAwesomeIcons.shoppingBasket, size: 25,color: Colors.white,),
          ),
          onPressed: (){
            showDialog(
              context: context,
              builder: (_){
                return FastShopDialog();
              }
            );
          },
        ),
        appBar: AppBar(
          title: Text('Menü'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(0, 40, 77,1),
          elevation: 0,
          actions: <Widget>[
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
                    },
                    title: 
                    snapshot.data[index].priority <= 0 ?
                    Text(' KAMPANYALI ÜRÜNLER ', style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, color: Colors.blueGrey),):
                    Text(snapshot.data[index].name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, color: Color.fromRGBO(0, 40, 77,1)),),
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
                                  color: Colors.blueGrey,
                                ),
                                )
                                :
                                Container(
                                  child: VerticalDivider(
                                  thickness: 5,
                                  endIndent: 0,
                                  color: Colors.black38,
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
                                  // ignore: unnecessary_statements
                                  dataProducts[index][i]['description'].toString() == '' ? null : Alert(
                                    context: context,
                                    title: dataProducts[index][i]['name'].toString(),
                                    desc: dataProducts[index][i]['description'].toString(),
                                    style: AlertStyle(
                                      animationDuration: Duration(milliseconds: 500),
                                      animationType: AnimationType.grow,
                                      titleStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800
                                      ),
                                      descStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300
                                      ),
                                      isCloseButton: false,
                                    ),
                                    buttons: [
                                      DialogButton(
                                        color: Color.fromRGBO(0, 40, 77,1),
                                        child: Text('Kapat', style: TextStyle(color: Colors.white),),
                                        onPressed: ()=> Navigator.pop(context),
                                      )
                                    ]
                                  ).show();
                                },
                                trailing: InkWell(
                                      child: dataProducts[index][i]['valid'].toString() == 'true' ? Container(padding: EdgeInsets.all(10),child: 
                                      snapshot.data[index].priority <= 0 ? 
                                      Icon(FontAwesomeIcons.plusSquare, color: Colors.blueGrey,size: 30,)
                                      :
                                      Icon(FontAwesomeIcons.plusSquare, color: Color.fromRGBO(0, 40, 77,1),size: 30,),)
                                       : Text(''),
                                      onTap: (){
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            timer = Timer(Duration(milliseconds: 800), () {
                                              Navigator.of(context).pop(false);
                                              timer.cancel();
                                            });
                                            return BackdropFilter(
                                              filter: prefix0.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                              child: AlertDialog(
                                              elevation: 3,
                                              backgroundColor: Colors.black45,
                                              shape: CircleBorder(
                                              ),
                                              title: Column(
                                                children: <Widget>[
                                                  Icon(Icons.check, color: Colors.green, size: 70,),
                                                  SizedBox(height: 10,),
                                                  Text('Ekleniyor..', style: TextStyle(color: Colors.white),)
                                                ],
                                              ),
                                            ),
                                            );
                                          });
                                        if(this.mounted) {
                                            var currentItemId = dataProducts[index][i]['id'];
                                            switches = false;
                                            if (listItems == null) {
                                                  setState(() {
                                                    var items = new AddItemtoShopCart(
                                                    id: dataProducts[index][i]["id"],
                                                    name: dataProducts[index][i]["name"],
                                                    price: dataProducts[index][i]["price"],
                                                    itemCount: 1,
                                                );
                                                  listItems.add(items);
                                                  });
                                            } else {
                                              bool ifExist = false;
                                              for (var k = 0; k <listItems.length; k++) {
                                                if (currentItemId ==listItems[k].id) {
                                                  ifExist = true;
                                                  setState(() {
                                                  });
                                                }
                                              }
                                              if (ifExist) {
                                                for (var j = 0; j <listItems.length; j++) {
                                                  if (listItems[j].id ==
                                                      currentItemId) {listItems[j]
                                                        .itemCount++;
                                                  }
                                                }
                                              } else {
                                                setState(() {
                                                  var items = new AddItemtoShopCart( // var items = new AddItemtoShopCart(
                                                  id: dataProducts[index][i]["id"],
                                                  name: dataProducts[index][i]["name"],
                                                  price: dataProducts[index][i]["price"],
                                                  itemCount: 1,
                                                );
                                                listItems.add(items);
                                                });
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

class FastShopDialog extends StatefulWidget {
  @override
  _FastShopDialogState createState() => _FastShopDialogState();
}

class _FastShopDialogState extends State<FastShopDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: prefix0.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        elevation: 1,
          backgroundColor: Colors.black54,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          title: Text('Hızlı Sepet', style: TextStyle(color: Colors.white),),
          contentPadding: EdgeInsets.all(20),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
              padding: EdgeInsets.all(20),
              child: Text('Sepeti Boşalt', style: TextStyle(color: Colors.white)),
              onPressed: (){
                setState(() {
                  if(listItems.length != 0){
                    listItems.clear();
                  }
                });
              },
            ),
            FlatButton(
              padding: EdgeInsets.all(20),
              child: Text(
                'Sepeti Al', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  if (keyShared != '') {
                    if(inside == false){
                    listItems.length != 0 ?
                    Navigator.of(context).pushReplacementNamed('/endcart')
                        :
                    Alert(
                      style: alertStyle,
                      title: 'Sepet Boş',
                      desc: 'Boş sepet onaylanamaz',
                      buttons: [
                        DialogButton(
                          color: Color.fromRGBO(0, 40, 77,1),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Tamam',
                            style: TextStyle(color: Colors.white),),
                        ),
                      ],
                      context: context,
                    ).show();
                  } else {
                    Alert(
                      style: alertStyle,
                      title: 'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                      buttons: [
                        DialogButton(
                          color: Color.fromRGBO(0, 40, 77,1),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Tamam', style: TextStyle(
                              color: Colors.white),),
                        ),
                        DialogButton(
                          color: Color.fromRGBO(0, 40, 77,1),
                          onPressed: () =>
                              Navigator.of(context)
                                  .pushReplacementNamed('/login'),
                          child: Text('Üye girişi', style: TextStyle(
                              color: Colors.white),),
                        ),
                      ], context: context,
                    ).show();
                  }
                  }else {
                    Alert(
                      style: alertStyle,
                      title: 'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                      buttons: [
                        DialogButton(
                          color: Color.fromRGBO(0, 40, 77,1),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Tamam', style: TextStyle(
                              color: Colors.white),),
                        ),
                        DialogButton(
                          color: Color.fromRGBO(0, 40, 77,1),
                          onPressed: () =>
                              Navigator.of(context)
                                  .pushReplacementNamed('/login'),
                          child: Text('Üye girişi', style: TextStyle(
                              color: Colors.white),),
                        ),
                      ], context: context,
                    ).show();
                  }
                }
            ),
            FlatButton(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.close, color: Colors.deepOrangeAccent,),
              onPressed: () => Navigator.pop(context, false),
            ),
              ],
            ),

          ],
          content: Container(
            width: double.maxFinite,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: 
                listItems.length != 0 ? 
                <Widget>[
                  for(var i = 0; i < listItems.length; i++)
                    ExpansionTile(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MaterialButton(
                              elevation: 0,
                              minWidth: 10,
                              color: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  listItems[i].itemCount = 0;
                                  listItems.removeAt(i);
                                });
                              },
                              child: Icon(Icons.delete, color: Colors.white,),
                            ),
                            MaterialButton(
                              elevation: 0,
                              minWidth: 10,
                              color: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  listItems[i].itemCount++;
                                });
                              },
                              child: Icon(
                                Icons.add_circle, color: Colors.white,),
                            ),
                            MaterialButton(
                              elevation: 0,
                              minWidth: 10,
                              color: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  if (listItems[i].itemCount == 1) {
                                    listItems[i].itemCount = 1;
                                  } else {
                                    listItems[i].itemCount--;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.remove_circle, color: Colors.white,),
                            ),
                          ],
                        )
                      ],
                      title: Text(listItems[i].itemCount.toString() + ' ' +
                          listItems[i].name.toString(),
                        style: TextStyle(color: Colors.white),),
                      trailing: Text(
                        (listItems[i].price.toInt()*listItems[i].itemCount.toInt()).toString() + ' TL',
                        style: TextStyle(color: Colors.white),),
                    )
                ] : 
                <Widget>[
                  Center(child: Text('Sepet Boş..', style: TextStyle(color: Colors.white),),)
                ]
            ),
          )
      ),
    );
  }
  var alertStyle = AlertStyle(
    isCloseButton: false,
    isOverlayTapDismiss: false,
    backgroundColor: Colors.white,
    animationDuration: Duration(milliseconds: 500),
    animationType: AnimationType.grow,
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );
}
