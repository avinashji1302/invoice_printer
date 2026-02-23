import 'package:app/core/common/common_text_field.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';

import 'package:app/screens/invoice/view/invoice_preview_screen.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:app/screens/invoice/widgets/add_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CreateInvoiceScreen extends StatelessWidget {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();

    final grandTotal = provider.invoicesItems.fold<double>(
      0,
      (sum, item) {
        final price = double.tryParse(item.price) ?? 0.0;
        final quantity = double.tryParse(item.quantity) ?? 0.0;
        return sum + (price * quantity);
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Create Invoice"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              /// CLIENT CARD
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const _sectionTitle("Client Information"),

                    const SizedBox(height: 12),

                    CustomTextField(
                      hint: "Customer Name",
                      controller: provider.cutomerNmae,
                    ),

                    const SizedBox(height: 12),

                    CustomTextField(
                      hint: "Customer Phone",
                      controller: provider.phoneController,
                      textInputType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ITEMS CARD
              _card(
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _sectionTitle("Items"),

                        TextButton.icon(
                          onPressed: () {
                            showAddItemDialog(context, provider);
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    provider.invoicesItems.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "No items added",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.invoicesItems.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 20),
                            itemBuilder: (_, index) {

                              final item =
                                  provider.invoicesItems[index];

                              final price =
                                  double.tryParse(item.price) ?? 0.0;

                              final quantity =
                                  double.tryParse(item.quantity) ?? 0.0;

                              final total =
                                  price * quantity;

                              return Row(
                                children: [

                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      "$quantity × ₹$price",
                                      style: const TextStyle(
                                        color:
                                            AppColors.textSecondary,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      "₹$total",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// TOTAL CARD
              _card(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Grand Total",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      "₹ $grandTotal",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InvoicePreviewScreen(
                          items:
                              provider.invoicesItems,
                          customerNamer:
                              provider.cutomerNmae.text,
                          phoneNumber:
                              provider.phoneController.text,
                          grnadTotal: grandTotal,
                        ),
                      ),
                    );
                  },

                  child: const Text(
                    "Preview Invoice",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),

      child: child,
    );
  }
}

class _sectionTitle extends StatelessWidget {
  final String title;
  const _sectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

