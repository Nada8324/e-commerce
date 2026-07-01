import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectx_task_shopapp/features/Cart/CartModel/cart_model.dart';
import 'package:connectx_task_shopapp/features/Details/DetailsScreen.dart';
import 'package:connectx_task_shopapp/features/EachCategory/cubit/states.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/states.dart';
import 'package:connectx_task_shopapp/models/productmodel.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:connectx_task_shopapp/shared/network/end_points.dart';
import 'package:connectx_task_shopapp/shared/network/remote/diohelper.dart';
import 'package:connectx_task_shopapp/features/EachCategory/EachCategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';

class CategoryCubit extends Cubit<ShopCategoryStates> {
  static CategoryCubit get(context) => BlocProvider.of(context);
  CategoryCubit() : super(ShopCategoryInitialState());

  EachCategoryModel? Model;
  List<ProductsModel> products = [];
  var search_controller = TextEditingController();
  void getCategoryProduct() async {
    emit(ShopCategoryLoadingState());

    try {
      final value = await DioHelper.getData(
        url: '$Products/${EachCategoryScreen.slug ?? EachCategoryScreen.name}',
        token: token,
      );

      Model = EachCategoryModel.fromjson(value.data);
      products = Model!.data!.products ?? [];

      if (token != null) {
        await getFavoriteProducts(token!);

        for (final product in products) {
          product.in_favorites = ListOfFavorite.any((e) => e.id == product.id);
        }
      }

      emit(ShopCategorySuccessState());
    } catch (error) {
      emit(ShopCategoryErrorState(error.toString()));
    }
  }

  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> toggleFavoriteProduct(
      String userId, ProductsModel product) async {
    final favoriteDoc = await usersCollection
        .doc(userId)
        .collection('favorites')
        .doc(product.id.toString())
        .get();
    emit(DetailsToogleLoading());
    if (favoriteDoc.exists) {
      product.in_favorites = false;
      await usersCollection
          .doc(userId)
          .collection('favorites')
          .doc(product.id.toString())
          .delete();
      emit(DeatilsAddToWishList());
    } else {
      product.in_favorites = true;

      await usersCollection
          .doc(userId)
          .collection('favorites')
          .doc(product.id.toString())
          .set(product.toMap());
      emit(DeatilsAddToWishList());
    }
  }

  Widget BuildProductItem(ProductsModel model, BuildContext context) {
    final homeCubit = HomeCubit.get(context);
    final cartItem = homeCubit.getCartItem(model.id!);

    model.in_cart = cartItem != null;
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          DetailsScreen.productsModel = model;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetailsScreen(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image(
                    image: NetworkImage("${model.images![0]}"),
                    height: 203.h,
                    width: 160.w,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return SizedBox(
                          height: 203.h,
                          width: 160.w,
                          child: const Center(
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ),
                        );
                      }
                    }),
                InkWell(
                  onTap: () {
                    if (token != null) {
                      CategoryCubit.get(context)
                          .toggleFavoriteProduct(token!, model);
                    }
                  },
                  child: model.in_favorites!
                      ? const Icon(Iconsax.heart5)
                      : const Icon(Iconsax.heart),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: 35,
              child: Text('${model.name}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 11.sp,
                    color: HexColor("#1D1E20"),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          Row(
  children: [
    Text(
      '${model.price}',
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 13.sp,
        color: HexColor("#1D1E20"),
      ),
    ),

    const SizedBox(width: 6),

 const SizedBox(width: 6),

    BlocBuilder<HomeCubit, HomeScreenStates>(
  builder: (context, state) {
    final homeCubit = HomeCubit.get(context);

    CartModel? cartItem =
        homeCubit.getCartItem(model.id);

        if (cartItem == null) {
          return InkWell(
            onTap: () async {

              if (token == null) return;

              await homeCubit.addToCart(
                token!,
                model,
              );

              emit(ShopCategorySuccessState());
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5),
              height: 30.h,
              decoration: BoxDecoration(
                color: HexColor("#4A4E69"),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Add To Cart",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }

        return Container(
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              InkWell(
                onTap: () async {

                  await homeCubit.decreaseQuantity(
                    token!,
                    cartItem,
                  );

                  emit(ShopCategorySuccessState());
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              Text(
                "${cartItem.quantity}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              InkWell(
                onTap: () async {

                  await homeCubit.increaseQuantity(
                    token!,
                    cartItem,
                  );

                  emit(ShopCategorySuccessState());
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ],
),   ],
        ),
      ),
    );
  }
}
