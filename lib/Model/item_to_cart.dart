import 'package:flutter/material.dart';

class AddItemtoShopCart{
  int id;
  String name;
  double price;
  int itemCount;

  AddItemtoShopCart({
    @required this.id, 
    @required this.name, 
    @required this.price,
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