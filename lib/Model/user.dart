class User{
  final int id;
  final String name;
  final String lastname;
  final String phoneNumber;
  final String address;
  final String created;

  User({
    this.id,
    this.name,
    this.lastname,
    this.phoneNumber,
    this.address,
    this.created
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['value']['id'],
        name = json['value']['name'],
        lastname = json['value']['lastname'],
        phoneNumber = json['value']['phoneNumber'],
        address = json['value']['address'],
        created = json['value']['created'];
}