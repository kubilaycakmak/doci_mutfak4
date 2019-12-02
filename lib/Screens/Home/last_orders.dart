import 'package:doci_mutfak4/Connection/api.dart';
import 'package:doci_mutfak4/Connection/api_calls.dart';
import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'menu.dart';

var backgroundImage = new AssetImage('assets/images/sepetbos.png');
var image = new Image(image: backgroundImage, fit: BoxFit.fitWidth,);

List productItems;
List orderCount;
bool orderStatus;
double taste = 3;
double rating = 0;
double speed = 3;
String keyAgain;
List starCount;
double services = 3;
var selectedId;
bool noUser;
bool finishRaiting = false;
var _commentController = new TextEditingController();

class LastOrders extends StatefulWidget {
  LastOrders({Key key}) : super(key: key);

  @override
  _LastOrdersState createState() => _LastOrdersState();
}

class _LastOrdersState extends State<LastOrders> {

// ignore: missing_return
Future<List> _fetchData() async {
    var response = await http.get(Uri.encodeFull(orderUrl),
        headers: {
          "authorization": keyShared,
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
    }else if(
      response.statusCode == 401){
        if(username != null){
          setState(() {
            postItself(context, '');
          });
        }else{
          print('username');
        }
    }
    else{
      throw Exception('Failed to get products');
    }
  }

  Future<List> _fetchData1() async {
    var response = await http.get(Uri.encodeFull(orderUrl),
        headers: {
          "authorization": keyShared,
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

      // ignore: missing_return
  Future<http.Response> _fetchRaiting() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    Map data =
    {
        "taste": taste.toInt(),
        "speed": speed.toInt(),
        "service": services.toInt(),
        "comment": _commentController.text
    };
    var body = json.encode(data);
    print(body);
    getKey();
    key = prefs.getString('LastKey');
    var response = await http.put(Uri.encodeFull(ratingUrl),
      headers: {
        "authorization": key,
        "content-Type": "application/json"
      },
      body: body
      );
      print('selected Id : ' + selectedId.toString());
      print('response body ' + response.body);
      if(response.statusCode == 201){
        finishRaiting = true;
      }else{
        finishRaiting = false;
        print('key burada: ' + keyShared);
        throw Exception('failed to load raiting');
      }
  }
  

  @override
  void initState() {
    super.initState();
    getKey();
  }

  @override
  void dispose() { 
    getKey();
    super.dispose();
  }
  var star = Icon(Icons.star);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
       child: Scaffold(
         appBar: AppBar(
           elevation: 0,
           title: Text('Siparişlerim'),
           centerTitle: true,
           backgroundColor: Color.fromRGBO(0, 40, 77,1),
         ),
         body: 
         key == null?
         Container(
           child: ListView(
             children: <Widget>[
               SizedBox(height: (SizeConfig.blockSizeVertical * SizeConfig.blockSizeHorizontal) * 3,),
               image,
               SizedBox(height: 20,),
               Container(
                 child: Text('Eski siparişlerini görüntülemek için, lüften giriş yap!',textAlign: TextAlign.center,),
                 padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 10),
               )
               ,
               SizedBox(height: 20,),
               Container(
                 height: 70,
                 child: FlatButton(
                   child: Text('Girişe git', style: TextStyle(fontSize: 30, color: Color.fromRGBO(0, 40, 77,1)),),
                   onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                 ),
               )
             ],
           ),
         ) : noUser == true ? Container(
           child: ListView(
             children: <Widget>[
               image,
               SizedBox(height: 20,),
               Container(
                 child: Text('Eski siparişlerini görüntülemek için, lüften giriş yap!',textAlign: TextAlign.center,),
                 padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 10),
               )
               ,
               SizedBox(height: 20,),
               Container(
                 child: FlatButton(
                   child: Text('Girişe git'),
                   onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                 ),
               )
             ],
           ),
         ):
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
                       color: Color.fromRGBO(0, 40, 77,0.9),
                       child: ExpansionTile(
                         trailing: Icon(FontAwesomeIcons.arrowAltCircleDown, color: Colors.white,),
                         onExpansionChanged: (val){
                           _commentController.text = '';
                         },
                         title: Text(snapshot.data[index]['created']
                             .replaceAll('Nov','Kasım').replaceAll('Oct', 'Ekim').replaceAll('Dec','Aralık').replaceAll('Jan','Ocak')
                             .replaceAll('Feb','Şubat').replaceAll('Mar', 'Mart').replaceAll('Ap','Nisan').replaceAll('May','Mayıs')
                             .replaceAll('June','Haziran').replaceAll('July', 'Temmuz').replaceAll('Agu','Ağustos').replaceAll('Sep','Eylül')
                             .replaceAll('AM','').replaceAll('PM', '')
                         ,style: TextStyle(color: Colors.white),
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
                             title: Text('Toplam ödenen :',style: TextStyle(color: Colors.white),),
                             subtitle: Text(snapshot.data[index]['price'].toInt().toString() + ' TL', style: TextStyle(color: Colors.white,fontSize: 30),),
                           ),
                           ListTile(
                             title: Text('Sipariş Adresi : ',style: TextStyle(color: Colors.white),),
                             subtitle: Text(snapshot.data[index]['address'].toString(),style: TextStyle(color: Colors.white),),
                           ),
                           ListTile(
                             title: Text('Sipariş Notu : ',style: TextStyle(color: Colors.white),),
                             subtitle: Text(snapshot.data[index]['note'].toString(),style: TextStyle(color: Colors.white),),
                           ),
                           Column(
                            children: 
                            snapshot.data[index]['status'] == false ?
                            snapshot.data[index]['orderRating'] == null ? <Widget>[
                              Text('Tat', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),),
                              SizedBox(height: 5,),
                              SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                if(v <= 0){
                                  v = 1;
                                }
                                taste = v;
                                setState(() {});
                              },
                              starCount: 5,
                              rating: taste,
                              size: 40.0,
                              color: Colors.yellow[600],
                              borderColor: Colors.white38,
                              spacing:3.0
                            ),
                            SizedBox(height: 5,),
                            Text('Hiz', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),),
                            SizedBox(height: 5,),
                            SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                if(v <= 0){
                                  v = 1;
                                }
                                speed = v;
                                setState(() {});
                              },
                              starCount: 5,
                              rating: speed,
                              size: 40.0,
                              color: Colors.yellow[600],
                              borderColor: Colors.white38,
                              spacing:3.0
                            ),
                            SizedBox(height: 5,),
                            Text('Servis', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),),
                            SizedBox(height: 5,),
                            SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                if(v <= 0){
                                  v = 1;
                                }
                                services = v;
                                setState(() {});
                              },
                              starCount: 5,
                              rating: services,
                              size: 40.0,
                              color: Colors.yellow[600],
                              borderColor: Colors.white38,
                              spacing:3.0
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              maxLines: 3,
                              controller: _commentController,
                              decoration: InputDecoration(
                                labelText: 'Yorumunuz',
                                prefixIcon: Icon(Icons.comment, color: Colors.yellow[900],),
                                labelStyle: TextStyle(backgroundColor: Colors.yellow[900], color: Colors.white, fontSize: 20, letterSpacing: 1.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: BorderSide(
                                    color: Colors.white
                                  ),
                                )
                              ),
                              cursorColor: Colors.white,
                            ),
                            SizedBox(height: 10,),
                            CupertinoButton(
                            child: Text('    Siparişi Oyla    '),
                            onPressed: (){
                              setState(() {
                                 selectedId = orderCount[index]['id'];
                                _fetchRaiting();
                              });
                            },
                            color: Colors.yellow[800],
                          ),
                            ] : <Widget>[
                              ListTile(
                                title: Text('Oylamanız :',style: TextStyle(color: Colors.white),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text('Hız :     ',style: TextStyle(color: Colors.white),),
                                        for(int i = 0; i< snapshot.data[index]['orderRating']["speed"].toInt(); i++) Icon(Icons.star, color: Colors.orangeAccent,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('Servis :',style: TextStyle(color: Colors.white),),
                                        for(int i = 0; i< snapshot.data[index]['orderRating']["service"].toInt(); i++) Icon(Icons.star, color: Colors.orangeAccent,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('Tat:      ',style: TextStyle(color: Colors.white),),
                                        for(int i = 0; i< snapshot.data[index]['orderRating']["taste"].toInt(); i++) Icon(Icons.star, color: Colors.orangeAccent,),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text('Yorumunuz :',style: TextStyle(color: Colors.white),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(snapshot.data[index]['orderRating']['comment'].toString(),style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              ),
                            ] : <Widget>[
                              Text("Siparişi oylayabilmeniz için, restaurant'ın siparişi onaylaması gerekmektedir", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)
                            ],
                          ),
                          Divider(
                            height: 20,
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
                                     address: snapshot.data[index]['address'].toString()
                                   );
                                   print(items.address);
                                   listItems.add(items);
                                 }
                                 Alert(
                                   context:context,
                                   type: AlertType.success,
                                   style: AlertStyle(
                                    animationDuration: Duration(milliseconds: 500),
                                    animationType: AnimationType.grow,
                                    isCloseButton: false,
                                    isOverlayTapDismiss: false,
                                  ),
                                   title: 'Sipariş başarıyla sepete eklendi',
                                   buttons: [
                                     DialogButton(
                                       color: Color.fromRGBO(0, 40, 77,1),
                                       onPressed: () => Navigator.of(context).pop(),
                                       child: Text('Tamam', style: TextStyle(color: Colors.white),),
                                     ),
                                   ],
                                 ).show();
                               });
                             },
                             color: Colors.yellow[800],
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