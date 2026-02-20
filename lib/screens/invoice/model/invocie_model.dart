class InvoiceModel {
  final int? id;
  final String customerName;
    final String phone;
  final DateTime createdAt;
  final List<InvoiceItem> items;
 final  String total;

  InvoiceModel({
    this.id,
    required this.phone,
    required this.customerName,
    required this.createdAt,
    required this.items,
    required this.total
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone':phone,
      'total':total,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map, List<InvoiceItem> items) {
    return InvoiceModel(
      id: map['id'] as int?,
      customerName: map['customerName'] as String,
      phone: map['customerPhone'] as String,
       total: map['total'],
      createdAt: DateTime.parse(map['createdAt'] as String),
      items: items,
    );
  }     
}


class InvoiceItem {
  final int? id;
  final String name;
  final String quantity;
  final String price;
  final int? invoiceId;

  InvoiceItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.invoiceId,
  });


Map<String, dynamic> toMap(int invoiceId) {
    return {
      'invoiceId': invoiceId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

}
