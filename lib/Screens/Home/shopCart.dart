import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Container(
        child: Text('SEPET BOS'),
      ),
    );
  }
}