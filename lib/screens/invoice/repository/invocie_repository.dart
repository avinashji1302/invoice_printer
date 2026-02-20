import 'package:app/screens/invoice/model/invocie_model.dart';

abstract class InvoiceRepository {
  Future<int> insertInvoice(InvoiceModel invoice);
  Future<List<InvoiceModel>> getAllInvoices();
  Future<void> deleteInvoice(int id);
}
