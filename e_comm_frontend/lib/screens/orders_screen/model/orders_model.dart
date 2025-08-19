class OrdersModel {
  int? status;
  String? message;
  List<Data>? data;

  OrdersModel({this.status, this.message, this.data});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? itemId;
  String? image;
  String? category;
  int? quantity;
  num? price;
  num? tprice;
  String? title;

  Data(
      {this.id,
      this.itemId,
      this.image,
      this.category,
      this.quantity,
      this.price,
      this.tprice,
      this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    image = json['image'];
    category = json['category'];
    quantity = json['quantity'];
    price = json['price'];
    tprice = json['tprice'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['image'] = image;
    data['category'] = category;
    data['quantity'] = quantity;
    data['price'] = price;
    data['tprice'] = tprice;
    data['title'] = title;
    return data;
  }
}