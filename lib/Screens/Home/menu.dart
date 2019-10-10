import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Components/Post.dart';
import 'dart:async';
import 'dart:convert';



class Menu extends StatefulWidget {
  Menu({Key key, Future<Post> post}) : super(key: key);
  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> {

  var cacheddata = new Map<int, Data>();
  var offsetLoaded = new Map<int, bool>();
  int _total = 0;
  List data;

  @override
  void initState() { 
        _getTotal().then((int total){
          setState(() {
           _total = total; 
          });
        });
        super.initState();
      }
    
    
      @override
      Widget build(BuildContext context) {
        
    
        var listView = ListView.builder(
          itemCount: _total,
          itemBuilder: (BuildContext context, int index){
            Data data = _getData(index);
            
                    return ListTile(
                      title: Text(data.value),
                    );
                  });
            
                return Scaffold(
                  appBar: AppBar(
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
            
              Future<List<Data>> _getDatas(int offset, int limit) async{
                String jsonString  = await _getJson(offset, limit);

                List list = json.decode(jsonString) as List;
                var datas = new List<Data>();
                list.forEach((element){
                  Map map = element as Map;
                  datas.add(new Data.fromMap(map));
                });
                return datas;
              }

              Future<String> _getJson(int offset, int limit) async{
                String json = "[";
                for(int i=offset; i<offset + limit; i++){
                  String id = i.toString();
                  String value = "value ($id)";
                  json +='{ "id":"$id","value":"$value" }';
                  if(i < offset + limit -1){
                    json += ",";
                  }
                }
                json += "]";
                return json;
              }
            
              Data _getData(int index) {
                Data data = cacheddata[index];
                if(data == null){
                  int offset = index ~/ 5 * 5;
                  if(!offsetLoaded.containsKey(offset)){
                    offsetLoaded.putIfAbsent(offset, ()=> true);
                    _getDatas(offset, 5)
                        .then((List<Data> datas) => _updateDatas(offset, datas));
                            }
                            data = Data.loading();
                          }
                          return data;
                        }
              
                Future<int> _getTotal() async {
                  return 1000;
                }
          
            void _updateDatas(int offset, List<Data> datas) {
              setState(() {
                for(int i=0; i < datas.length; i++){
                  cacheddata.putIfAbsent(offset + i, ()=> datas[i]);
                }
              });
              }
            }

            class Data{
              String id;
              String value;

              Data.loading(){
                value = "Loading...";
              }

              Data.fromMap(Map map){
                id = map['id'];
                value = map['value'];
              }
            }

