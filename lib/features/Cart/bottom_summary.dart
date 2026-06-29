import 'package:connectx_task_shopapp/features/Cart/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/orderPlaced/order_placed.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

Widget buildSummary(
  CartCubit cubit,
  BuildContext context,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DetailsOfCart(
            text1: "Subtotal",
            text2: cubit.totalPrice.toStringAsFixed(2),
          ),
          const SizedBox(height: 10),
          DetailsOfCart(
            text1: "Delivery",
            text2: cubit.delivery.toStringAsFixed(2),
          ),
          const SizedBox(height: 10),
          DetailsOfCart(
            text1: "VAT",
            text2: cubit.vat.toStringAsFixed(2),
          ),
          const Divider(),
          DetailsOfCart(
            text1: "Total",
            text2: cubit.finalPrice.toStringAsFixed(2),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor("#4A4E69"),
              ),
              onPressed: () async {
                await CartCubit.get(context).checkout(token!);
                Shopcubit.get(context).changeindex(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderPlacedScreen(),
                  ),
                );
              },
              child: Text(
                "Checkout",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
