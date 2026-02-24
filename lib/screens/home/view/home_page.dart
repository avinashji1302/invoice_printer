
import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/premium/water_mark_widget.dart';
import 'package:app/screens/home/view_model/home_provider.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:app/screens/invoice/view/invocie_screen.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();

    return WatermarkWidget(
      child: Scaffold(
        backgroundColor: AppColors.background,
      
        appBar: AppBar(
          title: const Text(
            "Invoices",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
        ),
      
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          elevation: 2,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>  CreateInvoiceScreen(),
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      
        body: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.invoices.isEmpty
            ? _emptyState()
            : Consumer<InvoiceProvider>(
              builder: (BuildContext context, provider, Widget? child) { 
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.invoices.length,
                  itemBuilder: (_, index) =>
                      _invoiceCard(context, provider.invoices[index] , index),
                );
               },
           
            ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        "No invoices yet",
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _invoiceCard(BuildContext context, InvoiceModel invoice , int index) {
    final invoiceProvider = context.watch<InvoiceProvider>();
    final homeProvider = context.watch<HomeProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        title: Text(
          invoice.customerName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "₹ ${invoice.total}",
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: AppColors.danger,
          ),
          onPressed: () async {
           invoiceProvider.removeItem(index);
            await homeProvider.deleteItem(invoice.id.toString());
          
          },
        ),
      ),
    );
  }
}
