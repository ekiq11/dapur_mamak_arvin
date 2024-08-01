class CartItem {
  String? id;
  String? title;
  double? price;
  int? qty;
  double? subtotal;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.qty,
    this.subtotal,
  });
}
