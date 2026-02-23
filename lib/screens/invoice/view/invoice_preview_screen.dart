import 'package:app/core/common/top_sncbar.dart';

import 'package:app/core/helper/pdf_generate.dart' as InvoicePdfService;
import 'package:app/screens/home/view/home_page.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final List<InvoiceItem> items;
  final String customerNamer;
  final String phoneNumber;
  final double grnadTotal;

  const InvoicePreviewScreen({
    super.key,
    required this.items,
    required this.customerNamer,
    required this.phoneNumber,
    required this.grnadTotal,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<InvoiceProvider>();

    final gst = 0.0;
    final totalWithGST = grnadTotal.toDouble() + gst.toDouble();

    provider.totalMoney = totalWithGST.toString();

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        title: const Text("Invoice Preview"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// INVOICE CARD
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// APP NAME
                      const Text(
                        "QuickBill",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Phone: $phoneNumber",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const Divider(height: 30),

                      /// CUSTOMER
                      const Text(
                        "Bill To",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        customerNamer,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ITEMS HEADER
                      Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Item",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Qty x Price",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Total",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// ITEMS LIST
                      Flexible(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (_, index) {
                            final item = items[index];

                            final price = double.tryParse(item.price) ?? 0;

                            final quantity = double.tryParse(item.quantity) ?? 0;

                            final total = price * quantity;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),

                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(item.name)),

                                  Expanded(child: Text("$quantity x $price")),

                                  Expanded(
                                    child: Text(
                                      "₹ $total",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
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

                      /// SUBTOTAL
                      _priceRow(title: "Subtotal", value: "₹ $grnadTotal"),

                      const SizedBox(height: 6),

                      /// GST
                      _priceRow(title: "GST", value: "₹ $gst"),

                      const Divider(height: 30),

                      /// FINAL TOTAL
                      _priceRow(
                        title: "Total",
                        value: "₹ $totalWithGST",
                        isBold: true,
                        isGreen: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                    
                      await InvoicePdfService.InvoicePdfService.saveAndOpen(
                        items: provider.invoicesItems,
                        customerName: provider.cutomerNmae.text,
                        phoneNumber: provider.phoneController.text,
                      );

                      await provider.addInvoice();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );

                       AppSnackBar.show(context, message: "Saved in your download folder.." , backgroundColor: Colors.green);
                    },
                    child: const Text("Save"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // await provider.addInvoice();

                      await InvoicePdfService.InvoicePdfService.shareToWhatsApp(
                        items: provider.invoicesItems,
                        customerName: provider.cutomerNmae.text,
                        phoneNumber: provider.phoneController.text,
                      );

                      await provider.addInvoice();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );

                     
                    },
                    child: const Text(" Share"),
                  ),
                ),

               
              ],
            ),
             SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget _priceRow({
    required String title,
    required String value,
    bool isBold = false,
    bool isGreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isGreen ? Colors.green : null,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
