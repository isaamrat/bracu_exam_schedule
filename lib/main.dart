import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summer22_final/pages/responsive.dart';
import 'package:summer22_final/pages/test_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'BRACU Exam Schedule',
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
        primarySwatch: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
        
        

      ),
      home: responsiveLayout(),
    );
  }
}
