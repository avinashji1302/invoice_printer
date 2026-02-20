import 'dart:io';
import 'package:app/screens/invoice/model/invocie_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

 Future<void> generateAndShare({
  required List<InvoiceItem> items,
  required String customerName,
  required String phoneNumber,
}) async {
  final pdf = pw.Document();

  // ✅ Calculate subtotal properly
  final subtotal = items.fold<int>(0, (sum, item) {
    final price = int.tryParse(item.price) ?? 0;
    final quantity = int.tryParse(item.quantity) ?? 0;
    return sum + (price * quantity);
  });

  final gst = 500; // same as your preview
  final totalWithGST = subtotal + gst;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "QuickBill",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),
            pw.Text("Phone: $phoneNumber"),

            pw.Divider(),

            pw.Text(
              "Bill To:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),

            pw.Text(customerName),

            pw.SizedBox(height: 20),

            pw.Text(
              "Items",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 10),

            // ✅ Items Table
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text("Item"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text("Qty"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text("Price"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text("Total"),
                  ),
                ]),

                ...items.map((item) {
                  final price = int.tryParse(item.price) ?? 0;
                  final quantity = int.tryParse(item.quantity) ?? 0;
                  final total = price * quantity;

                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(item.name),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(quantity.toString()),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("$price"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text("$total"),
                    ),
                  ]);
                }).toList(),
              ],
            ),

            pw.SizedBox(height: 20),

            // ✅ Subtotal
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Subtotal"),
                pw.Text("$subtotal"),
              ],
            ),

            pw.SizedBox(height: 5),

            // ✅ GST
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("GST"),
                pw.Text("$gst"),
              ],
            ),

            pw.Divider(),

            // ✅ Final Total
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Total",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "$totalWithGST",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  final directory = await getTemporaryDirectory();
  final file = File("${directory.path}/${DateTime.now().second}invoice.pdf");
  await file.writeAsBytes(await pdf.save());

  await Share.shareXFiles(
    [XFile(file.path)],
    text: "Here is your invoice",
  );
}