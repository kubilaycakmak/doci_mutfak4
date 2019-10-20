class Types{
  int tId;
  String tName;

  Types({
    this.tId, this.tName
  });
}

class Menus{
  int mId;
  String mName;
  String mDesc;
  int mPrice;
  List<Data> mDociProductTypes;
  bool isValid;
  String mDate;

  Menus({
    this.mId, this.mName, this.mDesc, this.mPrice, this.mDociProductTypes, this.isValid, this.mDate
  });

  factory Menus.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['mDociProductTypes'] as List;
    List<Data> mDociProductTypes = list.map((i) => Data.fromJson(i)).toList();

    return Menus(
      mId: parsedJson['id'],
      mName: parsedJson['name'],
      mDesc: parsedJson['description'],
      mPrice: parsedJson['price'],
      mDociProductTypes: mDociProductTypes,
      isValid: parsedJson['isValid'],
      mDate: parsedJson['created']
    );
  }
}

class Data{
  int dId;
  String dName;

  Data({
    this.dId, this.dName
  });

  factory Data.fromJson(Map<String, dynamic> parsedJson){
    return Data(
      dId: parsedJson['id'],
      dName: parsedJson['name']
    );
  }

}