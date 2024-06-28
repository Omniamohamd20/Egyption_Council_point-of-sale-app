class Order {
  int? id;
  String? label;
  double? totalPrice;
  double? discount;
  String? createdAt;
  int? clientId;
  String? clientName;
  String? clientPhone;
  String? clientAddress;
  // constructor
  Order.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    label = data["label"];
    totalPrice = data["totalPrice"];
    discount = data["discount"];
    createdAt = data["createdAt"];
    clientId = data["clientId"];
    clientName = data["clientName"];
    clientPhone = data["clientPhone"];
    clientAddress = data["clientAddress"];
  }
  // not used
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "label": label,
      "totalPrice": totalPrice,
      "discount": discount,
      "createdAt": createdAt,
      "clientId": clientId,
      "clientName": clientName,
      "clientPhone": clientPhone,
      "clientAddress": clientAddress
    };
  }
}
