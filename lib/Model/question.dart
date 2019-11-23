class Questions{
  int id;
  String question;

  Questions({this.id, this.question});

  factory Questions.fromJson(Map<String, dynamic> json){
    return Questions(
      id: json['id'],
      question: json['question']
    );
  }
}