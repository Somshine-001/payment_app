

class Product {
    final String name;
    final String detail;
    final int price;
    int stock;
    final List<String> imagePath;

    Product({
      required this.name,
      required this.detail,
      required this.price,
      required this.stock,
      required this.imagePath,
    });
  }