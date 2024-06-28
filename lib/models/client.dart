class ClientData{
  int? id;
  String? name;
  String? email;
  String? phone;
String? address;
  // constructor
  ClientData.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
     email = data["email"];
 phone = data["phone"];
address = data["address"];
  }

  int? get clientId => null;
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "phone": phone , "address":address,"email":email};
  }

  static fromMap(e) {}
}
