import 'package:doci_mutfak4/Model/products.dart';
import 'package:doci_mutfak4/Model/types.dart';

class Data{
  Types type;
  Products products;

  Data({
    this.type,
    this.products
  });

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
        type: json['types'],
        products: json['products']
    );
  }
}