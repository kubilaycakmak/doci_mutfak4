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
int _counter = 1;
var itemOfProducts;
Products products;
bool door = false;
var types;
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
  final ScrollController _scrollController = ScrollController();

  List dataProducts;
  var quantity = 1;
  TabController tabController;
  String url = 'http://68.183.222.16:8080/api/dociproduct/all';

  void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;
    if (keyContext != null) {
      // make sure that your widget is visibles
      _scrollController.animateTo(isExpanded ? ((SizeConfig.blockSizeVertical*7.6) * index) : previousOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  // ignore: missing_return
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      dataProducts = items["products"];
      List listOfProducts = dataProducts;
      return listOfProducts.toString();
    }
    else {
      throw Exception('Failed to get Types');
    }
  }

  Future<List<Types>> _fetchTypes() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      types = items;
      List<Types> listOfTypes = items["types"].map<Types>((json) {
        return Types.fromJson(json);
      }).toList();
      makeRequest();
      return listOfTypes;
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
  void dispose() {
    super.dispose();
    this.makeRequest();
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
          key: expansionTileKey,
          future: _fetchTypes(),
          builder: (BuildContext context, AsyncSnapshot<List<Types>> snapshot) {
            if (!snapshot.hasData)
              return Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center);
            return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  child: ExpansionTile(
                    onExpansionChanged: (val){
                      setState(() {
                        print(_scrollController);
                        if (val){
                          previousOffset = _scrollController.offset;
                        }
                        _scrollToSelectedContent(val, previousOffset, index, expansionTileKey);
                      });
                    },
                    initiallyExpanded: types['types'][index]['priority'] <= 0 ? true : false,
                    title: Text(snapshot.data[index].name),
                    children: <Widget>[
                      FutureBuilder<String>(
                          future: makeRequest(),
                          // ignore: missing_return
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshotProducts) {
                            if (!snapshotProducts.hasData)
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: dataProducts[index].length,
                              itemBuilder: (BuildContext context, int i) {
                                return Card(
                                  borderOnForeground: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Color.fromRGBO(128, 223, 255, 0.5),
                                      width: 1.0,
                                      ),
                                    ),
                                  child:  ExpansionTile(
                                    backgroundColor: dataProducts[index][i]['valid'].toString() == 'true' ? Colors.transparent : Colors.redAccent,
                                      title: Text(dataProducts[index][i]['name'].toString()),
                                      leading: InkWell(
                                        child: dataProducts[index][i]['valid'].toString() == 'true' ? Icon(Icons.add_circle_outline) : Text(''),
                                        highlightColor: Colors.green,
                                        focusColor: Colors.green,
                                        onTap: (){
                                          _showToast(context,
                                              "Ürün sepete eklenmiştir!");
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
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            currentSelected.toString() == dataProducts[index][i].toString() ?
                                            dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') : Text((dataProducts[index][i]['priceWithoutNoDiscount']*_counter).toInt().toString() +' TL',
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
                                            Text((dataProducts[index][i]["price"]*_counter).toInt().toString() +' TL') : Text(dataProducts[index][i]["price"].toInt().toString() +' TL'),
                                          ],
                                        ),
                                        children: <Widget>[
                                          dataProducts[index][i]['valid'].toString() == 'true' ?
                                          SizedBox(width: SizeConfig.blockSizeHorizontal * 80, child: Text(dataProducts[index][i]['description'],maxLines: 2,style: TextStyle(wordSpacing: 2),),)
                                              : Padding(padding: EdgeInsets.all(0),child: Card(child: Text('Bu ürün stokta yok', style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                                            color: Colors.red, elevation: 3, margin: EdgeInsets.all(0),),),
                                            SizedBox(height: 20,),
                                        ],
                                      ),
                                );
                              },
                            );
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: dataProducts[index].length,
                              itemBuilder: (BuildContext context, int i) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      width: 1.0,
                                      color: Colors.black26
                                      ),
                                    ),
                                  child:  ExpansionTile(
                                        backgroundColor: Colors.white,
                                        title: Text(dataProducts[index][i]['name'].toString()),
                                        leading: InkWell(
                                          child: dataProducts[index][i]['valid'].toString() == 'true' ? Icon(Icons.add_circle_outline) : Text(''),
                                          highlightColor: Colors.green,
                                          focusColor: Colors.green,
                                          onTap: (){
                                            _showToast(context,
                                                "Ürün sepete eklenmiştir!");
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
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            currentSelected.toString() == dataProducts[index][i].toString() ?
                                            dataProducts[index][i]['priceWithoutNoDiscount'].toInt() == 0 ? Text(' ') : Text((dataProducts[index][i]['priceWithoutNoDiscount']*_counter).toInt().toString() +' TL',
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
                                            Text((dataProducts[index][i]["price"]*_counter).toInt().toString() +' TL') : Text(dataProducts[index][i]["price"].toInt().toString() +' TL'),
                                          ],
                                        ),
                                        children: <Widget>[
                                          dataProducts[index][i]['valid'].toString() == 'true' ?
                                          SizedBox(width: SizeConfig.blockSizeHorizontal * 80, child: Text(dataProducts[index][i]['description'],maxLines: 2,style: TextStyle(wordSpacing: 2),),)
                                              : Padding(padding: EdgeInsets.all(0),child: Card(child: Text('Bu ürün stokta yok', style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                                            color: Colors.red, elevation: 3, margin: EdgeInsets.all(0),),),
                                          SizedBox(height: 20,),

                                        ],
                                      ),
                                );
                              },
                            );
                          }),
                    ],
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
    print('refreshing stocks...');
    if(this.mounted) {
      setState(() {
        _fetchTypes();
        makeRequest();
      });
    }
  }
}
