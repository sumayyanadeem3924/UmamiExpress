class OrderModel {
  final String orderId;
  final String customerUid;
  final List<dynamic> items;
  final double totalAmount;
  final String status; // Pending, Cooking, Out for Delivery, Delivered
  final int timestamp;

  OrderModel({
    required this.orderId,
    required this.customerUid,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.timestamp,
  });

  factory OrderModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return OrderModel(
      orderId: id,
      customerUid: json['customerUid'] ?? '',
      items: json['items'] ?? [],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      timestamp: json['orderTime'] ?? 0,
    );
  }
}