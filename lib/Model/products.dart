class Products{
  int id;
  String name;
  String desc;
  double priceWithoutNoDiscount;
  double price;
  bool isValid;
  String created;

  Products({
    this.id,
    this.name,
    this.desc,
    this.priceWithoutNoDiscount,
    this.price,
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
      isValid: json['isValid'],
      created: json['created']
    );
  }
}