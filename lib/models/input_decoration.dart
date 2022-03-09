import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Colors.purple, width: 2.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2.5,
      ),
    ),
  );
}
