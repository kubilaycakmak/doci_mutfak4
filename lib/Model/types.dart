class Types{
  int id;
  String name;
  int priority;

  Types({
    this.id,
    this.name,
    this.priority
  });

  factory Types.fromJson(Map<String, dynamic> json){
    return Types(
      id: json['id'],
      name: json['name'],
      priority: json['priority']
    );
  }
}