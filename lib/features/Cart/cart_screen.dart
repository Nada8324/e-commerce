import 'package:connectx_task_shopapp/features/Cart/bottom_summary.dart';
import 'package:connectx_task_shopapp/features/Cart/cart_item.dart';
import 'package:connectx_task_shopapp/features/Cart/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Cart/cubit/state.dart';
import 'package:connectx_task_shopapp/features/Cart/empty_cart.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit()..getCart(token!),
      child: BlocConsumer<CartCubit, CartStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = CartCubit.get(context);

          return Scaffold(
            backgroundColor: HexColor("#F5F6FA"),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "My Cart",
                style: GoogleFonts.inter(
                  color: HexColor("#1D1E20"),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: state is CartLoadingState
                ? const Center(child: CircularProgressIndicator())
                : cubit.cartItems.isEmpty
                    ? buildEmptyCart()
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (context, index) => buildCartItem(
                          cubit.cartItems[index],
                          cubit,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemCount: cubit.cartItems.length,
                      ),
            bottomNavigationBar:
                cubit.cartItems.isEmpty ? null : buildSummary(cubit,context),
          );
        },
      ),
    );
  }
}
