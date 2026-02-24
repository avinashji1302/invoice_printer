import 'dart:io';
import 'package:app/core/helper/water_mark_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/screens/invoice/model/invocie_model.dart';

class InvoicePdfService {

  static Future<File> generatePdfFile({
    required List<InvoiceItem> items,
    required String customerName,
    required String phoneNumber,
  }) async {

    final pdf = pw.Document();

    final subtotal = items.fold<double>(0, (sum, item) {
      final price = double.tryParse(item.price) ?? 0.0;
      final qty = double.tryParse(item.quantity) ?? 0.0;
      return sum + price * qty;
    });

    final gst = 0;
    final total = subtotal + gst;
    final invoiceNumber = DateTime.now().millisecondsSinceEpoch;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return  pw.Stack(
            children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "QuickBill",
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Invoice Generator",
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Invoice #$invoiceNumber"),
                      pw.Text(
                        "${DateTime.now()}",
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),

              pw.Text(
                "Bill To",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              pw.SizedBox(height: 5),
              pw.Text(customerName),
              pw.Text(phoneNumber),
              pw.SizedBox(height: 20),

              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _cell("Item", bold: true),
                      _cell("Qty", bold: true),
                      _cell("Price (Rs)", bold: true),
                      _cell("Total (Rs)", bold: true),
                    ],
                  ),

                  ...items.map((item) {
                    final price = double.tryParse(item.price) ?? 0.0;
                    final qty = double.tryParse(item.quantity) ?? 0.0;
                    final rowTotal = price * qty;

                    return pw.TableRow(
                      children: [
                        _cell(item.name),
                        _cell(qty.toString()),
                        _cell(price.toString()),
                        _cell(rowTotal.toString()),
                      ],
                    );
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 200,
                  child: pw.Column(
                    children: [
                      _row("Subtotal", subtotal.toDouble()),
                      _row("GST", gst.toDouble()),
                      pw.Divider(),
                      _row("Total (Rs)", total, bold: true),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              pw.Center(
                child: pw.Text(
                  "Thank you for your business!",
                  style: const pw.TextStyle(
                    color: PdfColors.grey,
                  ),
                ),
              ),
            ],
          ),

          buildWatermark(),
          
          ]);
        },
      ),
    );

    final dir = Directory("/storage/emulated/0/Download/QuickBill");

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File("${dir.path}/invoice_$invoiceNumber.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<File> saveAndOpen({
  required List<InvoiceItem> items,
  required String customerName,
  required String phoneNumber,
}) async {

  /// generate real PDF
  final file = await generatePdfFile(
    items: items,
    customerName: customerName,
    phoneNumber: phoneNumber,
  );

  print("PDF saved at: ${file.path}");

  /// open PDF viewer
  // await OpenFile.open(file.path);

  return file;
}

  static Future<void> shareToWhatsApp({
    required List<InvoiceItem> items,
    required String customerName,
    required String phoneNumber,
  }) async {

    final file = await generatePdfFile(
      items: items,
      customerName: customerName,
      phoneNumber: phoneNumber,
    );

    await Share.shareXFiles([XFile(file.path)]);

    final whatsapp = Uri.parse("https://wa.me/91$phoneNumber");

    if (await canLaunchUrl(whatsapp)) {
      await launchUrl(
        whatsapp,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

pw.Widget _cell(String text, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontWeight:
            bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget _row(String title, double value, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontWeight:
                bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value.toStringAsFixed(2),
          style: pw.TextStyle(
            fontWeight:
                bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}