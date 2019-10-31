class PaymentMethods {
  int id;
  String name;

  PaymentMethods({
    this.id,
    this.name
  });

  factory PaymentMethods.fromJson(Map<String, dynamic> json){
    return PaymentMethods(
        id: json['id'],
        name: json['name']
    );
  }
}