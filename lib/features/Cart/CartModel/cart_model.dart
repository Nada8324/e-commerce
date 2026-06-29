class CartModel {
  late int id;
  String? name;
  String? image;
  dynamic price;
  late int quantity;
  late bool inCart;

  CartModel({
    required this.id,
    this.name,
    this.image,
    this.price,
    this.quantity = 1,
    this.inCart = true,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    quantity = json['quantity'] ?? 1;
    inCart = json['in_cart'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'in_cart': inCart,
    };
  }

  double get totalPrice => quantity * (price as num).toDouble();
}