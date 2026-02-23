// import 'package:app/screens/home/view_model/home_provider.dart';
// import 'package:app/screens/invoice/model/invocie_model.dart';
// import 'package:app/screens/invoice/view/invocie_screen.dart';
// import 'package:app/screens/invoice/view_model/invoice_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InvoiceProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Invoices")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => CreateInvoiceScreen()),
//           );
//         },

//         child: const Icon(Icons.add),
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.invoices.isEmpty
//           ? const Center(child: Text("No Invoices Yet"))
//           : ListView.builder(
//               itemCount: provider.invoices.length,
//               itemBuilder: (context, index) {
//                 final invoice = provider.invoices[index];
//                 return _invoiceCard(context, invoice);
//               },
//             ),
//     );
//   }

//   Widget _invoiceCard(BuildContext context, InvoiceModel invoice) {
//     final provider = context.read<InvoiceProvider>();
//     final homeProverer = context.watch<HomeProvider>();

//     return Card(
//       margin: const EdgeInsets.all(12),
//       child: ListTile(
//         title: Text(invoice.customerName),
//         subtitle: Text("Total: ₹ ${invoice.total}"),
//         trailing: IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: () async {
//             await homeProverer.deleteItem(invoice.id.toString());
//             await provider.loadInvoices();
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:app/core/constants/app_colors.dart';
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
              builder: (_) => const CreateInvoiceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.invoices.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.invoices.length,
              itemBuilder: (_, index) =>
                  _invoiceCard(context, provider.invoices[index]),
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

  Widget _invoiceCard(BuildContext context, InvoiceModel invoice) {
    final invoiceProvider = context.read<InvoiceProvider>();
    final homeProvider = context.read<HomeProvider>();

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
            await homeProvider.deleteItem(invoice.id.toString());
            await invoiceProvider.loadInvoices();
          },
        ),
      ),
    );
  }
}
