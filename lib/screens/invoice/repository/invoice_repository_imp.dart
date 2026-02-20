import 'package:app/core/database/app_database.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/repository/invocie_repository.dart';
import 'package:flutter/cupertino.dart';

class InvoiceRepositoryImpl {
  final AppDatabase _database = AppDatabase();

Future<int> insertInvoice(InvoiceModel invoice) async {

  final db = await _database.database;

  debugPrint("===== INSERT INVOICE INTO DB =====");

  final invoiceId = await db.insert(
    "invoices",
    invoice.toMap(),
  );

  debugPrint("Invoice inserted with ID: $invoiceId");

  for (var item in invoice.items) {

    debugPrint("Inserting item: ${item.name}");

    await db.insert(
      "invoice_items",
      item.toMap(invoiceId),
    );
  }

  debugPrint("===== INSERT COMPLETE =====");

  return invoiceId;
}



 Future<List<InvoiceModel>> getAllInvoices() async {
  final db = await _database.database;

  final invoiceMaps = await db.query('invoices');
  List<InvoiceModel> invoices = [];

  for (var invoiceMap in invoiceMaps) {
    final invoiceId = invoiceMap['id'] as int;

    final itemMaps = await db.query(
      'invoice_items',
      where: 'invoiceId = ?',
      whereArgs: [invoiceId],
    );

    List<InvoiceItem> items = itemMaps.map((itemMap) {
      return InvoiceItem(
        name: itemMap['name'] as String,
        quantity: itemMap['quantity'] as String,
        price: itemMap['price'] as String,
      );
    }).toList();

    invoices.add(InvoiceModel.fromMap(invoiceMap, items));
  }

  return invoices;
}


  Future<void> deleteInvoice(int id) async {
    final db = await _database.database;

    await db.transaction((txn) async {
      await txn.delete(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [id],
      );

      await txn.delete('invoices', where: 'id = ?', whereArgs: [id]);
    });
  }
}
