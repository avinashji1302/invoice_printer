// import 'package:flutter/material.dart';

// class InvoicePreviewScreen extends StatelessWidget {
//   const InvoicePreviewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Invoice Preview"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             const Text(
//               "QuickBill",
//               style: TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             const Text("Phone: 9876543210"),
//             const Divider(height: 30),

//             const Text(
//               "Bill To:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             const Text("Rahul Sharma"),
//             const SizedBox(height: 20),

//             const Text(
//               "Items",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             const ListTile(
//               contentPadding: EdgeInsets.zero,
//               title: Text("Website Development"),
//               trailing: Text("₹ 4000"),
//             ),

//             const Divider(),

//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Subtotal"),
//                 Text("₹ 4000"),
//               ],
//             ),
//             const SizedBox(height: 5),

//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("GST"),
//                 Text("₹ 500"),
//               ],
//             ),

//             const Divider(height: 30),

//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "₹ 4500",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 ),
//               ],
//             ),

//             const Spacer(),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text("Generate PDF"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
