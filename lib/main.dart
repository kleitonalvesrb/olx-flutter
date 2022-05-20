import 'package:flutter/material.dart';
import 'package:olx/RouteGenerator.dart';
import 'package:olx/views/Anuncios.dart';
import 'package:olx/views/Login.dart';

ThemeData temaPadrao = ThemeData(
  primaryColor: const Color(0xff9c27b0),
);


void main() {

  runApp(MaterialApp(
    title: "OLX",
    home: const Anuncios(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
