import 'package:easy_pos/models/product.dart';

class OrderItem {
  // for save
  int? orderId;
  int? productId;
  int? productCount;
  String? productName;
  String? productDescription;
  double? productPrice;
  String? productImage;
  // for ui
  Product? product;
  OrderItem({
    this.orderId,
    this.productId,
    this.productCount,
    this.product,
  });
  OrderItem.fromJson(Map<String, dynamic> data) {
    orderId = data["orderId"];
    productId = data["productId"];
    productCount = data["productCount"];
    productName = data["productName"];
    productDescription = data["productDescription"];
    productPrice = data["productPrice"];
    productImage = data["productImage"];
    product = Product.fromJson(data);
  }
  // not used
  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "productId": productId,
      "productCount": productCount,
    };
  }
}
