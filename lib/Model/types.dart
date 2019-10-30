class Types{

  int id;
  String name;

  Types({
    this.id,
    this.name
  });

  factory Types.fromJson(Map<String, dynamic> json){
    return Types(
      id: json['id'],
      name: json['name']
    );
  }
}