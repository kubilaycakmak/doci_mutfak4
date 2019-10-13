import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Components/Post.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  Menu({Key key, Future<Post> post}) : super(key: key);
  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> {

  String url = 'http://68.183.222.16:8080/api/dociproduct/all';
  List dataTypes;
  List dataProducts;
  var count;
  Future<String> makeRequest() async{
    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": 'application/json'
    });

    setState(() {
      var extractData = json.decode(response.body);
      dataTypes = extractData["types"];
      dataProducts = extractData["products"];
    });
  }
    @override
  void initState() { 
    this.makeRequest();
  }

    
      @override
      Widget build(BuildContext context) {
        
        var listView = ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: dataTypes.length,
          itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text(dataTypes[index]['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),textScaleFactor: 1.3,),
                      subtitle: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: dataProducts[index].length,
                        itemBuilder: (context, i){
                          return ListTile(
                            isThreeLine: false,
                            dense: true,
                            title: Text(dataProducts[index][i]['name']),
                            subtitle: Text(dataProducts[index][i]['description']),
                            trailing: Text(dataProducts[index][i]['price'].toString() + ' TL'),
                            leading: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.add_box,),
                              onPressed: null,
                            ),
                            onTap: ()=> print(dataProducts[index][i]['name']),
                          );
                        },
                      ),
                    );
                  });
            
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.deepOrange,
                    title: Text('Doci Mutfak'),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.shopping_basket),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/cart'),
                      )
                    ],
                  ),
                  body: listView,
                );
              }
  }