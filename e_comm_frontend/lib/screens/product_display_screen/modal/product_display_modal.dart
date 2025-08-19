class ProductDisplayModal {
  int? status;
  String? message;
  Data? data;

  ProductDisplayModal({this.status, this.message, this.data});

  ProductDisplayModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  num? nprice;
  num? mprice;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  Data(
      {this.id,
      this.title,
      this.nprice,
      this.mprice,
      this.description,
      this.category,
      this.image,
      this.rating});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    nprice = json['nprice'];
    mprice = json['mprice'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating =
        json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['nprice'] = nprice;
    data['mprice'] = mprice;
    data['description'] = description;
    data['category'] = category;
    data['image'] = image;
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    return data;
  }
}

class Rating {
  num? rate;
  num? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['count'] = count;
    return data;
  }
}