import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:doci_mutfak4/Model/size_config.dart';

import 'menu.dart';

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
  bool orderStatus;
  double taste = 3;
  double rating = 0;
  double speed = 3;
  double services = 3;
  var keyShared;
  var selectedId;
  bool finishRaiting = false;
  var _commentController = new TextEditingController();
    getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
  } 

  Future<List> _fetchData() async {
    var response = await http.get(Uri.encodeFull(orderUrl),
        headers: {
          "authorization": key,
        });
    if(response.statusCode == 200){
        final item = json.decode(response.body);
        orderCount = item;
        if(orderCount != null){
            orderStatus = true;
        }else{
            orderStatus = false;
        }
        return orderCount;
    }else{
      throw Exception('Failed to get products');
    }
  }
  // ignore: missing_return
  Future<http.Response> _fetchRaiting() async{
    Map data =
    {
        "taste": taste.toInt(),
        "speed": speed.toInt(),
        "service": services.toInt(),
        "comment": _commentController.text
    };
    var body = json.encode(data);
    print(body);
    var response = await http.put(Uri.encodeFull('http://68.183.222.16:8080/api/order/rate?orderId=$selectedId'),
      headers: {
        "Authorization": key,
        "content-Type": "application/json"
      },
      body: body
      );
      print('selected Id : ' + selectedId.toString());

      print('response body ' + response.body);
      
      if(response.statusCode == 201){
        setState(() {
          finishRaiting = true;
        });
        
      }else{
        setState(() {
          finishRaiting = false;
        });
        throw Exception('failed to load raiting');
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
      if(orderCount != null){
          orderStatus = true;
        }else{
          orderStatus = false;
        }
      for(var i=0;i<orderCount.length;i++){
        productItems = item[i]['products'];
      }
      return productItems;
    }else{
      throw Exception('Failed to get products');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      this.getKey();
      this._fetchData();
      this._fetchData1();
    });

  }

  @override
  void dispose() { 
    this.getKey();
    this._fetchData();
    this._fetchData1();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Container(
       child: Scaffold(
         appBar: AppBar(
           elevation: 0,
           title: Text('Siparişlerim'),
           centerTitle: true,
           backgroundColor: Colors.lightBlueAccent,
         ),
         body: 
         key == null ?//keyde olabilir.
         Container(
           child: ListView(
             children: <Widget>[
               image,
               SizedBox(height: 20,),
               Container(
                 child: Text('Eski siparişlerini görüntülemek için, lüften giriş yap!',textAlign: TextAlign.center,),
                 padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 10),
               ),
               SizedBox(height: 20,),
               Container(
                 child: FlatButton(
                   child: Text('Girişe git'),
                   onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                 ),
               )
             ],
           ),
         ) :
         orderStatus == false ? Container(
           child: ListView(
              children: <Widget>[
                SizedBox(height: 20,),
                Text('Hala Sipariş vermedin mi ?',textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Text('Hemen yan menüye geçip lezzetli yemekleri incele!',textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Icon(Icons.arrow_back)
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
                         onExpansionChanged: (val){
                           _commentController.text = '';
                         },
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
                                       trailing: Text((orderCount[index]['products'][i]['dociProduct']['price'].toInt()*orderCount[index]['products'][i]['quantity']).toString() + ' TL'),
                                     ),
                                   );
                                 },
                               );
                             },
                           ),
                           ListTile(
                             title: Text('Toplam ödenen :'),
                             subtitle: Text(snapshot.data[index]['price'].toInt().toString() + ' TL', style: TextStyle(fontSize: 30),),
                           ),
                           ListTile(
                             title: Text('Sipariş Notu : '),
                             subtitle: Text(snapshot.data[index]['note'].toString()),
                           ),
                           Column(
                            children: 
                            snapshot.data[index]['status'] == false ?
                            snapshot.data[index]['orderRating'] == null ? <Widget>[
                              Text('Tat'),
                              SizedBox(height: 5,),
                              SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                taste = v;
                                setState(() {});
                              },
                              starCount: 5,
                              rating: taste,
                              size: 40.0,
                              color: Colors.lightBlueAccent,
                              borderColor: Colors.black26,
                              spacing:3.0
                            ),
                            SizedBox(height: 5,),
                            Text('Hiz'),
                            SizedBox(height: 5,),
                            SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                speed = v;
                                setState(() {});
                              },
                              starCount: 5,
                              rating: speed,
                              size: 40.0,
                              color: Colors.lightBlueAccent,
                              borderColor: Colors.black26,
                              spacing:3.0
                            ),
                            SizedBox(height: 5,),
                            Text('Servis'),
                            SizedBox(height: 5,),
                            SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                services = v;
                                setState(() {});
                              },
                              starCount: 5,
                              rating: services,
                              size: 40.0,
                              color: Colors.lightBlueAccent,
                              borderColor: Colors.black26,
                              spacing:3.0
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              maxLines: 3,
                              controller: _commentController,
                              decoration: InputDecoration(
                                labelText: 'Yorumunuz',
                                labelStyle: TextStyle(backgroundColor: Colors.lightBlueAccent, color: Colors.white, fontSize: 20, letterSpacing: 1.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                )
                              ),
                            ),
                            SizedBox(height: 10,),
                            CupertinoButton(
                            child: Text('Degerlendirmeyi Onayla'),
                            onPressed: (){
                              setState(() {
                                selectedId = orderCount[index]['id'];
                                _fetchRaiting();
                                if(finishRaiting == false){
                                  print('oylama bitmemis');
                                }
                                else{
                                  print('oylama bitmis');
                                }
                                print(selectedId);
                              });
                            },
                            color: Colors.lightBlueAccent,
                          ),
                            ] : <Widget>[
                              ListTile(
                                title: Text('Oylamanız :'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(' Hız : ' + snapshot.data[index]['orderRating']["speed"].toString() + ' yıldız'),
                                    Text(' Servis : ' + snapshot.data[index]['orderRating']["service"].toString() + ' yıldız'),
                                    Text(' Tat : ' + snapshot.data[index]['orderRating']["taste"].toString() + ' yıldız'),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text('Yorumunuz :'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(snapshot.data[index]['orderRating']['comment'].toString()),
                                  ],
                                ),
                              ),
                              

                            ] : <Widget>[
                              Text('Siparişi oylayabilmeniz için, restaurant ın siparişi onaylaması gerekmektedir', textAlign: TextAlign.center,)
                            ],
                          ),
                          
                          SizedBox(height: 10,),
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
       ),
    );
  }
}