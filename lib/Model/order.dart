class Orders{
  int id;

  Orders(this.id);
} 

class Order{
  var product;
  String note;
  Map payment;
  String address;
  String phoneNumber;

  Order(this.product, this.note, this.payment, this.address, this.phoneNumber);

  Map<String, dynamic> toJson() =>
      {
        'products': product,
        'note': note,
        'paymentMethod':payment,
        'address':address,
        'phoneNumber':phoneNumber
      };
}