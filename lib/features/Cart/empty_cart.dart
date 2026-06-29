import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildEmptyCart() {
  return Center(
    child: Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [

        const Icon(
          Icons.shopping_cart_outlined,
          size: 90,
          color: Colors.grey,
        ),

        const SizedBox(height: 20),

        Text(
          "Your Cart is Empty",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Add products to start shopping",
          style: GoogleFonts.inter(
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}