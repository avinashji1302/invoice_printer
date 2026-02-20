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

    return Scaffold(
      appBar: AppBar(title: const Text("Invoices")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateInvoiceScreen()),
          );
        },

        child: const Icon(Icons.add),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.invoices.isEmpty
          ? const Center(child: Text("No Invoices Yet"))
          : ListView.builder(
              itemCount: provider.invoices.length,
              itemBuilder: (context, index) {
                final invoice = provider.invoices[index];
                return _invoiceCard(context, invoice);
              },
            ),
    );
  }

  Widget _invoiceCard(BuildContext context, InvoiceModel invoice) {
    final provider = context.read<InvoiceProvider>();
    final homeProverer = context.watch<HomeProvider>();

    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(invoice.customerName),
        subtitle: Text("Total: ₹ ${invoice.total}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await homeProverer.deleteItem(invoice.id.toString());
            await provider.loadInvoices();
          },
        ),
      ),
    );
  }
}
