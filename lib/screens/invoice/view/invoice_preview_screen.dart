import 'package:app/core/helper/pdf_generate.dart';
import 'package:app/core/helper/pdf_generate.dart' as InvoicePdfService;
import 'package:app/screens/home/view/home_page.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicePreviewScreen extends StatelessWidget {
  List<InvoiceItem> items;
  String customerNamer;
  String phoneNumber;
  int grnadTotal;
  InvoicePreviewScreen({
    super.key,
    required this.items,
    required this.customerNamer,
    required this.phoneNumber,
    required this.grnadTotal,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();
    int gst = 500;
    int totalWithGST = grnadTotal + 500;
     provider.totalMoney= totalWithGST.toString();
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Preview")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "QuickBill",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text("Phone: $phoneNumber"),
              const Divider(height: 30),

              const Text(
                "Bill To:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(customerNamer),
              const SizedBox(height: 20),

              const Text(
                "Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 198,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final invoiceItem = items[index];
                    final price = int.tryParse(invoiceItem.price) ?? 0;
                    final quantity = int.tryParse(invoiceItem.quantity) ?? 0;
                    final totalPrice = quantity * price;

                    grnadTotal = grnadTotal + totalPrice;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text(invoiceItem.name)),
                          Expanded(
                            child: Text(
                              "${invoiceItem.quantity} × ${invoiceItem.price}",
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "₹ $totalPrice",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal"),
                  Text("₹ ${grnadTotal.toString()}"),
                ],
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("GST"), Text("₹ $gst")],
              ),

              const Divider(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹ $totalWithGST",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await InvoicePdfService.generateAndShare(
                      items: items,
                      customerName: customerNamer,
                      phoneNumber: phoneNumber,
                    );
                    await provider.addInvoice();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text("Generate PDF"),
                ),
              ),

              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.addInvoice();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
