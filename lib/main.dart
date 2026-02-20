import 'package:app/screens/home/view_model/home_provider.dart';
import 'package:app/screens/invoice/view_model/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InvoiceProvider()..loadInvoices(),
        ),

        ChangeNotifierProvider(
          create: (_) => HomeProvider()
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
