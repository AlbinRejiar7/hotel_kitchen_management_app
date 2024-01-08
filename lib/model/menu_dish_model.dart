class MenuItems {
  String dishName;
  String imageUrl;
  String itemId;
  String price;

  MenuItems({
    required this.dishName,
    required this.imageUrl,
    required this.itemId,
    required this.price,
  });

  // Factory method to create a Dish from a Map
  factory MenuItems.fromMap(Map<String, dynamic> map) {
    return MenuItems(
      dishName: map['dishName'],
      imageUrl: map['imageUrl'],
      itemId: map['itemId'],
      price: map['price'],
    );
  }

  // Convert Dish to a Map
  Map<String, dynamic> toMap() {
    return {
      'dishName': dishName,
      'imageUrl': imageUrl,
      'itemId': itemId,
      'price': price.toString(),
    };
  }
}
