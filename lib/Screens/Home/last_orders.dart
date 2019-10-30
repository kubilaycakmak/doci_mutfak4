import 'package:doci_mutfak4/Screens/Account/login_register.dart' as prefix0;
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LastOrders extends StatefulWidget {
  LastOrders({Key key}) : super(key: key);

  @override
  _LastOrdersState createState() => _LastOrdersState();
}

class _LastOrdersState extends State<LastOrders> {
  final String orderUrl = 'http://68.183.222.16:8080/api/order/user';
  List productItems;
  List orderCount;
  // ignore: missing_return
  Future<List> _fetchOrders() async{
    var response = await http.get(Uri.encodeFull(orderUrl),
      headers: {
        "authorization": key,
      });
    if(response.statusCode == 200){
      print('basarili');
      final item = json.decode(response.body);
      productItems = item[1]['products'];
      orderCount = item;
      print(productItems);
      print(orderCount.length);
    }
  }

//  Future<String> _fetchProduct() async {
//    var response = await http
//        .get(Uri.encodeFull(url), headers: {"Accept": 'application/json'});
//    if (response.statusCode == 200) {
//      final items = json.decode(response.body);
//      final productItems = items['products'];
//      List listOfProducts = productItems;
//      return listOfProducts.toString();
//    } else {
//      throw Exception('Failed to get Types');
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    this._fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text('Siparişlerim'),
           centerTitle: true,
           backgroundColor: Colors.lightBlueAccent,
         ),
         body: Container(
           child: FlatButton(
             child: Text('fetch'),
             onPressed: _fetchOrders,
           ),
         ),
       ),
    );
  }
}