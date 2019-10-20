import 'package:doci_mutfak4/Model/item_to_cart.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:flutter/material.dart';


void _showToast(BuildContext context, String desc) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(desc),
        action: SnackBarAction(
            label: 'Gizle', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    double _count = 0;

      setState(() {
        for (var item in listItems) {
          _count = _count + item.price * item.itemCount;
        }
      });

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index){
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(listItems[index].itemCount.toString() + ' x ' + listItems[index].name),
                  subtitle: Text('Urunu sepetten cikartmak icin basili tutunuz!'),
                  trailing: Text(((listItems[index].price)*(listItems[index].itemCount)).toInt().toString() + ' TL'),
                  onLongPress: (){
                    _showToast(context, "Urun Sepetten Cikartildi!");
                    setState(() {
                      listItems.removeAt(index);
                    });
                  },
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("+"),
                      onPressed: (){
                        setState(() {
                          listItems[index].itemCount++; 
                        });
                      },
                ),
                    RaisedButton(
                      child: Text("-"),
                        onPressed: (){
                        setState(() {
                          if (listItems[index].itemCount != 1) {
                            listItems[index].itemCount--; 
                          }
                        });
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text("Tutar: "),
                  subtitle: Text(_count.toString() + " TL"),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  color: Colors.lightBlueAccent,
                  onPressed: (){},
                  child: Text('Siparisi ver!',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}