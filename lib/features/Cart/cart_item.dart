import 'package:connectx_task_shopapp/features/Cart/CartModel/cart_model.dart';
import 'package:connectx_task_shopapp/features/Cart/cubit/cubit.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
Widget buildCartItem(
    CartModel model,
    CartCubit cubit,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            model.image!,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "\$${model.price}",
                style: GoogleFonts.inter(
                  color: HexColor("#4A4E69"),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  InkWell(
                    onTap: () {
                      cubit.decreaseQuantity(
                        model,
                        token!,
                      );
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor:
                          HexColor("#F5F6FA"),
                      child: const Icon(
                        Icons.remove,
                        size: 18,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15),
                    child: Text(
                      "${model.quantity}",
                      style: GoogleFonts.inter(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      cubit.increaseQuantity(
                        model,
                        token!,
                      );
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor:
                          HexColor("#4A4E69"),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            cubit.removeFromCart(
              model,
              token!,
            );
          },
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}