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
         ),
       ),
    );
  }
}