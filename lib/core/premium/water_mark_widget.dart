import 'package:flutter/material.dart';
import '../premium/premium_controller.dart';

class WatermarkWidget extends StatelessWidget {

  final Widget child;

  const WatermarkWidget({required this.child});

  @override
  Widget build(BuildContext context) {

    if (PremiumController.isPremium) {
      return child;
    }

    return Stack(
      children: [

        child,

        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Opacity(
              opacity: 0.15,
              child: Transform.rotate(
                angle: -0.5,
                child: Text(
                  "Subscribe QuickBill to remove Watermark",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

}