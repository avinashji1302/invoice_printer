import 'package:app/core/premium/premium_controller.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildWatermark() {

  if (PremiumController.isPremium) {
    return pw.Container();
  }

  return pw.Center(
    child: pw.Opacity(
      opacity: 0.2,
      child: pw.Transform.rotate(
        angle: 0.5,
        child: pw.Text(
          "Subscribe QuickBill to remove Watermark",
          style: pw.TextStyle(
            fontSize: 50,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    ),
  );

}