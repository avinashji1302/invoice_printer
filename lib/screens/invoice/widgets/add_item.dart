

import 'package:app/core/common/common_text_field.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:flutter/material.dart';

void showAddItemDialog(BuildContext context, InvoiceProvider provider) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// TITLE
              const Text(
                "Add Item",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// ITEM NAME
              CustomTextField(hint: "Item Name", controller: provider.itemName),

              const SizedBox(height: 14),

              /// QUANTITY
              CustomTextField(
                hint: "Quantity",
                controller: provider.numberOfItem,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 14),

              /// PRICE
              CustomTextField(
                hint: "Price",
                controller: provider.priceConttroller,
                textInputType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              /// BUTTONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// ADD
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (provider.itemName.text.isEmpty ||
                            provider.priceConttroller.text.isEmpty ||
                            provider.numberOfItem.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );

                          return;
                        }

                        final item = InvoiceItem(
                          name: provider.itemName.text,
                          price: provider.priceConttroller.text,
                          quantity: provider.numberOfItem.text,
                        );

                        provider.addItem(item);

                        /// CLEAR FIELDS
                        provider.itemName.clear();
                        provider.priceConttroller.clear();
                        provider.numberOfItem.clear();

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add Item",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
