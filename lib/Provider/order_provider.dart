import '../Provider/cart_provider.dart';

class Order {
  final String id;
  final List<CartItem> products;
  final double ammount;
  final DateTime dateTime;
  Order({
    required this.id,
    required this.products,
    required this.ammount,
    required this.dateTime,
  });
}
