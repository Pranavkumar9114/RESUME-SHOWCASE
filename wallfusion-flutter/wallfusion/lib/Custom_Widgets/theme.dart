// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static var buttonColor;

  static ThemeData LightTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.poppins().fontFamily,
        // fontFamily: GoogleFonts.aboreto().fontFamily, // Set font family globally
        // textTheme: GoogleFonts.aboretoTextTheme(
        //   Theme.of(context).textTheme,
        // ),
        cardColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: darkbluishcolor,
        ),
        focusColor: darkbluishcolor,
        hintColor: darkbluishcolor,
        canvasColor: creamcolor,
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 222, 211, 211),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          toolbarTextStyle: Theme.of(context).textTheme.bodyMedium,
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.black,
      canvasColor: darkcreamcolor,
      focusColor: lightbluishcolor,
      buttonTheme: ButtonThemeData(
        buttonColor: lightbluishcolor,
      ),
      hintColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0.0,
        // ignore: duplicate_ignore
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(color: Colors.white),
        toolbarTextStyle: Theme.of(context).textTheme.bodyMedium,
        // titleTextStyle: TextStyle(color: Colors.white),
      ));

  //color
  // ignore: duplicate_ignore
  // ignore: prefer_const_constructors
  static Color creamcolor = Color(0xfff5f5f5);
  static Color darkcreamcolor = Vx.gray900;
  // ignore: duplicate_ignore
  // ignore: prefer_const_constructors
  static Color darkbluishcolor = Color.fromARGB(255, 44, 37, 83);
  // ignore: duplicate_ignore
  // ignore: prefer_const_constructors
  static Color lightbluishcolor = Color.fromARGB(255, 94, 91, 186);
}
