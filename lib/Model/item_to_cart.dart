import 'package:flutter/material.dart';

class AddItemtoShopCart{
  int id;
  String name;
  double price;
  int quantity;
  int itemCount;


  AddItemtoShopCart({
    @required this.id, 
    @required this.name,
    @required this.price,
    this.quantity,
    this.itemCount
    });
}

int get id{
  return id;
}

String get name{
  return name;
}

double get price{
  return price;
}

int get itemCount{
  return itemCount;
}

int get quantity{
  return quantity;
}