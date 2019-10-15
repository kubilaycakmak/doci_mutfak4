import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Product extends Object{
  int id;
  String name;
  String description;
  int price;
  List dociProductTypes;
  bool isValid;
  DateTime created;

  Product({this.id, this.name, this.description, this.price, this.dociProductTypes, this.isValid, this.created});

  factory Product.fromJson(Map<String, dynamic> json){
    if(json == null){
      throw FormatException("Null JSON provided to Products");
    }

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      dociProductTypes: json['dociProductTypes'] 
        != null ? List<String>.from(json['dociProductTypes'])
        : null,
      isValid: json['isValid'], 
      created: json['created'],
    );
  }
}