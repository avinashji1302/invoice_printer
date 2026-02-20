import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/repository/invoice_repository_imp.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
    bool _isLoading = false;
  bool get isLoading => _isLoading;
  

  Future<void> deleteItem(String id) async {

  final parsedId = int.tryParse(id);

  if (parsedId != null) {

    await _repository.deleteInvoice(parsedId);

  } else {

    debugPrint("Invalid ID: $id");

  }
}
    
}
