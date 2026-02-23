import 'dart:io';

import 'package:app/core/common/top_sncbar.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';

import 'package:app/screens/invoice/repository/invoice_repository_imp.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceProvider extends ChangeNotifier {
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  final cutomerNmae = TextEditingController();
  final phoneController = TextEditingController();
  final numberOfItem = TextEditingController();
  final priceConttroller = TextEditingController();
  final itemName = TextEditingController();
  String totalMoney = "";
  List<InvoiceModel> _invoices = [];
  List<InvoiceModel> get invoices => _invoices;

  List<InvoiceItem> _invoicesItems = [];
  List<InvoiceItem> get invoicesItems => _invoicesItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadInvoices() async {
    debugPrint("===== LOADING INVOICES =====");

    _isLoading = true;
    notifyListeners();

    _invoices = await _repository.getAllInvoices();

    debugPrint("Total invoices loaded: ${_invoices.length}");
    debugPrint("Total invoices loaded: ${_invoices}");

    _isLoading = false;
    notifyListeners();
  }

  void addItem(InvoiceItem invocieItem) {
    _invoicesItems.add(invocieItem);
    notifyListeners();
  }

  Future<void> addInvoice() async {
    debugPrint("===== ADD INVOICE START =====");

    debugPrint("Customer Name: ${cutomerNmae.text}");
    debugPrint("Phone: ${phoneController.text}");

    debugPrint("Item Name: ${itemName.text}");
    debugPrint("Item Price: ${priceConttroller.text}");
    debugPrint("Item Quantity: ${numberOfItem.text}");

    final invoice = InvoiceModel(
      phone: phoneController.text,
      customerName: cutomerNmae.text,
      total: totalMoney,
      createdAt: DateTime.now(),
      items: _invoicesItems,
    );

    debugPrint("Invoice object created");

    final response = await _repository.insertInvoice(invoice);

    debugPrint("Insert response: $response");

    cutomerNmae.clear();
    numberOfItem.clear();
    phoneController.clear();
    totalMoney = '';
    _invoicesItems = [];

    await loadInvoices();

    debugPrint("===== ADD INVOICE END =====");
  }



  void removeItem(int index){
    _invoices.removeAt(index);

    notifyListeners();
  }

  Future<void> savePdf(BuildContext context) async {
    final pdf = pw.Document();

    /// Download folder path
    final downloadDir = Directory("/storage/emulated/0/Download/QuickBill");

    /// Create folder if not exists
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    /// File path
    final file = File(
      "${downloadDir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );

    /// Save file
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at: ${downloadDir}");

    /// Show snackbar with path
    AppSnackBar.show(
      context,
      message: "PDF saved in $file",
      backgroundColor: Colors.green,
    );

    await OpenFile.open(file.path);
  }
}
