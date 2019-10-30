import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<AddItemtoShopCart> listItems = new List();
class LastOrders extends StatefulWidget {
  LastOrders({Key key}) : super(key: key);

  @override
  _LastOrdersState createState() => _LastOrdersState();
}

class _LastOrdersState extends State<LastOrders> {
  final String orderUrl = 'http://68.183.222.16:8080/api/order/user';
  List productItems;
  List orderCount;

  Future<List> _fetchData() async {
    var response = await http.get(Uri.encodeFull(orderUrl),
        headers: {
          "authorization": key,
        });
    if(response.statusCode == 200){
      print('basarili');
      final item = json.decode(response.body);
      orderCount = item;
      return orderCount;
    }else{
      throw Exception('Failed to get products');
    }
  }
  Future<List> _fetchData1() async {
    var response = await http.get(Uri.encodeFull(orderUrl),
        headers: {
          "authorization": key,
        });
    if(response.statusCode == 200){
      print('basarili');
      final item = json.decode(response.body);
      orderCount = item;
      for(var i=0;i<orderCount.length;i++){
        productItems = item[i]['products'];
      }
      return productItems;
    }else{
      throw Exception('Failed to get products');
    }
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
           child: FutureBuilder<List>(
             future: _fetchData(),
             builder: (BuildContext context, AsyncSnapshot<List> snapshot){
               if(!snapshot.hasData)
                 return Container(
                     child: CircularProgressIndicator(),
                     alignment: Alignment.center);
               return ListView.builder(
                 itemCount: orderCount.length,
                 itemBuilder: (BuildContext context, int index){
                   return Card(
                     child: ExpansionTile(
                       title: Text(snapshot.data[index]['created'].toString()),
                       children: <Widget>[
                         FutureBuilder<List>(
                           future: _fetchData1(),
                           builder: (BuildContext context, AsyncSnapshot<List> snapshot1){
                             if(!snapshot1.hasData)
                               return Container(
                                   child: CircularProgressIndicator(),
                                   alignment: Alignment.center);
                             return ListView.builder(
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               scrollDirection: Axis.vertical,
                               itemCount: orderCount[index]['products'].length,
                               itemBuilder: (BuildContext context, int i){
                                 return Card(
                                   child: ListTile(
                                     title:
                                       Row(
                                         children: <Widget>[
                                           Text(orderCount[index]['products'][i]['quantity'].toString(), style: TextStyle(color: Colors.blue),),
                                           SizedBox(width: 10,),
                                           Text(orderCount[index]['products'][i]['dociProduct']['name'].toString()),
                                         ],
                                       ),
                                     trailing: Text(orderCount[index]['products'][i]['dociProduct']['price'].toInt().toString() + ' TL'),
                                   ),
                                 );
                               },
                             );
                           },
                         ),
                         ListTile(
                           title: Text('Sipariş Notu : '),
                           subtitle: Text(snapshot.data[index]['note'].toString()),
                         ),
                         ListTile(
                           title: Text('Sipariş Tamamlandı mı? : '),
                           subtitle: snapshot.data[index]['status'] == false ? Text('Hayır') : Text('Evet'),
                         ),
                         CupertinoButton(
                           onPressed: (){
                             setState(() {
                               for(var i=0;i<orderCount[index]['products'].length;i++){
                                 var items = new AddItemtoShopCart(
                                   id: orderCount[index]['products'][i]['dociProduct']['id'],
                                   name: orderCount[index]['products'][i]['dociProduct']['name'],
                                   price: orderCount[index]['products'][i]['dociProduct']['price'],
                                   itemCount: orderCount[index]['products'][i]['quantity'],
                                   quantity: orderCount[index]['products'][i]['quantity'],
                                 );
                                 listItems.add(items);
                               }
                             });
                           },
                           color: Colors.lightBlueAccent,
                           child: Text('Siparişi Tekrarla'),
                         ),
                         SizedBox(height: 10,)
                       ],
                     ),
                   );
                 },
               );
             },
           )
         ),
       ),
    );
  }
}