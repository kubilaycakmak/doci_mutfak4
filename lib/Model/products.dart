class Products{
  int id;
  String name;
  String desc;
  double priceWithoutNoDiscount;
  double price;
  List dociProductTypes;
  bool isValid;
  String created;

  Products({
    this.id,
    this.name,
    this.desc,
    this.priceWithoutNoDiscount,
    this.price,
    this.dociProductTypes,
    this.isValid,
    this.created
  });

  factory Products.fromJson(Map<String, dynamic> json){
    return Products(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      priceWithoutNoDiscount: json['priceWithoutNoDiscount'],
      price: json['price'],
      dociProductTypes: json['dociProductTypes'] as List,
      isValid: json['isValid'],
      created: json['created']
    );
  }
}