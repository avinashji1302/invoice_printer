import 'package:app/core/common/common_text_field.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/view/invoice_preview_screen.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateInvoiceScreen extends StatelessWidget {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();
   final grnadTotal = provider.invoicesItems.fold<int>(
  0,
  (sum, item) {
    final price = int.tryParse(item.price) ?? 0;
    final quantity = int.tryParse(item.quantity) ?? 0;
    return sum + (price * quantity);
  },
);
    return Scaffold(
      appBar: AppBar(title: const Text("Create Invoice"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- CLIENT INFO ----------------
              const SectionTitle(title: "Client Information"),
              const SizedBox(height: 12),

              CustomTextField(
                hint: "Client Name",
                controller: provider.cutomerNmae,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: "Client Phone",
                controller: provider.phoneController,
              ),
              SizedBox(
                height: 198,
                child: ListView.builder(
                  itemCount: provider.invoicesItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final invoiceItem = provider.invoicesItems[index];
                    final price = int.tryParse(invoiceItem.price) ?? 0;
                    final quantity = int.tryParse(invoiceItem.quantity) ?? 0;
                    final totalPrice = quantity * price;
                    // grnadTotal=grnadTotal+totalPrice;
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
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showAddItemDialog(context, provider);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Item"),
                ),
              ),

              const SizedBox(height: 24),

              // /// ---------------- CHARGES ----------------
              // const SectionTitle(title: "Charges"),
              // const SizedBox(height: 12),

              // const CustomTextField(hint: "GST (%)"),
              // const SizedBox(height: 12),
              // const CustomTextField(hint: "Discount"),
              const SizedBox(height: 24),

              /// ---------------- TOTAL ----------------
              const Divider(),
              const SizedBox(height: 12),

               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹ $grnadTotal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// ---------------- SAVE BUTTON ----------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // provider.addInvoice();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InvoicePreviewScreen(
                          items: provider.invoicesItems,
                          customerNamer: provider.cutomerNmae.text,
                          phoneNumber: provider.phoneController.text,
                          grnadTotal:grnadTotal
                        ),
                      ),
                    );
                  },
                  child: const Text("Save Invoice"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- REUSABLE WIDGETS ----------------

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

void showAddItemDialog(BuildContext context, InvoiceProvider provider) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(hint: "Item Name", controller: provider.itemName),

            const SizedBox(height: 12),
            CustomTextField(
              hint: "Price",
              controller: provider.priceConttroller,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              hint: "Quantity",
              controller: provider.numberOfItem,
              textInputType: TextInputType.number,
            ),
          ],
        ),

        actions: [
          /// Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          /// Submit Button
          ElevatedButton(
            onPressed: () {
              final item = InvoiceItem(
                name: provider.itemName.text,
                price: provider.priceConttroller.text,
                quantity: provider.numberOfItem.text,
              );

              provider.addItem(item);
             provider.itemName.clear();
              provider.priceConttroller.clear();
               provider.numberOfItem.clear();
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
        ],
      );
    },
  );
}
