import 'dart:core';

import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'menu.dart';
List tr = new List();
var backgroundImage = new AssetImage('assets/images/sepetbos.png');
var image = new Image(image: backgroundImage);

class LastOrders extends StatefulWidget {
  LastOrders({Key key}) : super(key: key);

  @override
  _LastOrdersState createState() => _LastOrdersState();
}

class _LastOrdersState extends State<LastOrders> {
  final String orderUrl = 'http://68.183.222.16:8080/api/order/user';
  List productItems;
  List orderCount;
  bool noOrder = false;

  // ignore: missing_return
  Future<List> _fetchData() async {
    var response = await http.get(Uri.encodeFull(orderUrl),
        headers: {
          "authorization": key,
        });
    if(response.statusCode == 200){
      if(response.body != null){
        final item = json.decode(response.body);
        orderCount = item;
        return orderCount;
      }else{
        noOrder = true;
      }
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
    return Scaffold(
         appBar: AppBar(
           elevation: 0,
           title: Text('Siparişlerim'),
           centerTitle: true,
           backgroundColor: Colors.lightBlueAccent,
         ),
         body: key == null ?
         Container(
           child: ListView(
             children: <Widget>[
               image,
               SizedBox(height: 20,),
               Text('Eski siparişlerini görüntülemek için, lüften giriş yap!',textAlign: TextAlign.center,),
               SizedBox(height: 20,),
               Container(
                 child: CupertinoButton(
                   child: Text('Girişe git'),
                   onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                   color: Colors.lightBlueAccent,
                 ),
               )
             ],
           ),
         ) :
         noOrder == true ? Container(
           child: ListView(
              children: <Widget>[
                image,
                SizedBox(height: 20,),
                Text('Hala Sipariş vermedin mi ?',textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Text('Hemen yan menüye geçip lezzetli yemekleri incele!',textAlign: TextAlign.center,)
              ],
           ),
         ) : Container(
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
                         title: Text(snapshot.data[index]['created']
                             .replaceAll('Nov','Kasım').replaceAll('Oct', 'Ekim').replaceAll('Dec','Aralık').replaceAll('Jan','Ocak')
                             .replaceAll('Feb','Şubat').replaceAll('Mar', 'Mart').replaceAll('Ap','Nisan').replaceAll('May','Mayıs')
                             .replaceAll('June','Haziran').replaceAll('July', 'Temmuz').replaceAll('Agu','Ağustos').replaceAll('Sep','Eylül')
                             .replaceAll('AM','').replaceAll('PM', '')
                         ),
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
                                       trailing: Text((orderCount[index]['products'][i]['dociProduct']['price']*orderCount[index]['products'][i]['quantity']).toInt().toString() + ' TL'),
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
                           
                           CupertinoButton(
                             onPressed: (){
                               setState(() {
                                 listItems.clear();
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
                                 Alert(
                                   context:context,
                                   type: AlertType.success,
                                   title: 'Sipariş başarıyla sepete eklendi',
                                   buttons: [
                                     DialogButton(
                                       onPressed: () => Navigator.of(context).pop(),
                                       child: Text('Tamam', style: TextStyle(color: Colors.white),),
                                     ),
                                   ],
                                 ).show();
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
    );
  }
}