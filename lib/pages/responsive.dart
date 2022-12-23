import 'package:flutter/material.dart';
import 'package:summer22_final/pages/new_desktop.dart';
import 'package:summer22_final/pages/test_page.dart';

class responsiveLayout extends StatelessWidget {
  const responsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth < 900) {
        return testPage();
      } else {
        return newDesktop(maxWidth: constrains.maxWidth);
      }
    });
  }
}
