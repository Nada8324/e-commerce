import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectx_task_shopapp/features/Details/DetailsScreen.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/states.dart';
import 'package:connectx_task_shopapp/features/Home/homeModel/HomeModel.dart';
import 'package:connectx_task_shopapp/features/Cart/CartModel/cart_model.dart';
import 'package:connectx_task_shopapp/models/category_model.dart';
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

class HomeCubit extends Cubit<HomeScreenStates> {
  HomeCubit() : super(HomeInitState());
  static HomeCubit get(context) => BlocProvider.of(context);
  var search_controller = TextEditingController();
  CategoryModel? categoryModel;
  HomeModel? homeModel;
  List<DataModel> categoryitemlist = [];
  List<ProductsModel> searchProducts = [];
  List<ProductsModel> prductItemList = [];
  Icon fav = const Icon(Iconsax.heart);
  List<CartModel> cartItems = [];

  void getHomeData() async {
    emit(HomeProductsLoadingState());
    await DioHelper.getData(url: Home, token: token).then((value) async {
      homeModel = HomeModel.fromJson(value.data);
      prductItemList = homeModel!.products;
      if (token != null) {
        await getFavoriteProducts(token!);
      }
      for (final element1 in prductItemList) {
        for (final element2 in ListOfFavorite) {
          if (element1.id == element2.id) {
            element1.in_favorites = true;
          }
        }
      }
      if (token != null) {
        await getCartProducts(token!);
      }
      for (final product in prductItemList) {
        product.in_cart = cartItems.any((e) => e.id == product.id);
      }
      emit(HomeProductsSuccessState());
    }).catchError((error) {
      emit(HomeProductsErrorState(error.toString()));
      print(error.toString());
    });
  }

  void search(String text) async {
    emit(SearchLoadingState());

    await DioHelper.getData(
      url: Search,
      query: {
        'q': text,
      },
    ).then((value) {
      HomeModel model = HomeModel.fromJson(value.data);

      searchProducts = model.products;

      emit(SearchSuccessState());
    }).catchError((error) {
      emit(SearchErrorState(error.toString()));
    });
  }

  void getCategories() async {
    emit(HomecatLoadingState());
    await DioHelper.getData(url: Categories).then((value) {
      categoryModel = CategoryModel.Fromjson(value.data);
      categoryitemlist = categoryModel!.data!.data!;
      emit(HomecatSuccessState());
    }).catchError((error) {
      emit(HomeCatErrorState(error.toString()));
      print(error.toString());
    });
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
    emit(ToogleLoading());
    if (favoriteDoc.exists) {
      product.in_favorites = false;
      await usersCollection
          .doc(userId)
          .collection('favorites')
          .doc(product.id.toString())
          .delete();
      emit(RemoveFromWishList());
    } else {
      product.in_favorites = true;

      await usersCollection
          .doc(userId)
          .collection('favorites')
          .doc(product.id.toString())
          .set(product.toMap());
      emit(AddToWishList());
    }
  }

  Future<void> getCartProducts(String userId) async {
    cartItems.clear();

    final snapshot = await usersCollection.doc(userId).collection('cart').get();

    cartItems = snapshot.docs.map((e) => CartModel.fromJson(e.data())).toList();

    emit(GetCartSuccessState());
  }

  CartModel? getCartItem(int id) {
    try {
      return cartItems.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addToCart(String userId, ProductsModel product) async {
    final docRef = usersCollection
        .doc(userId)
        .collection('cart')
        .doc(product.id.toString());

    final doc = await docRef.get();

    if (doc.exists) {
      int quantity = doc['quantity'];

      await docRef.update({
        'quantity': quantity + 1,
      });

      final item = cartItems.firstWhere((e) => e.id == product.id);
      item.quantity++;
    } else {
      final cartItem = CartModel(
        id: product.id,
        name: product.name,
        image: product.images?[0],
        price: product.price,
        quantity: 1,
        inCart: true,
      );

      await docRef.set(cartItem.toMap());

      cartItems.add(cartItem);
      product.in_cart = true;
    }

    emit(UpdateCartSuccessState());
  }

  Future<void> decreaseQuantity(
    String userId,
    CartModel product,
  ) async {
    if (product.quantity > 1) {
      product.quantity--;

      await usersCollection
          .doc(userId)
          .collection('cart')
          .doc(product.id.toString())
          .update({
        'quantity': product.quantity,
      });
    } else {
      await usersCollection
          .doc(userId)
          .collection('cart')
          .doc(product.id.toString())
          .delete();

      cartItems.removeWhere((e) => e.id == product.id);

      final homeProduct = prductItemList.firstWhere(
        (e) => e.id == product.id,
        orElse: () => ProductsModel(id: -1),
      );

      if (homeProduct.id != -1) {
        homeProduct.in_cart = false;
      }
    }

    emit(UpdateCartSuccessState());
  }

  Future<void> increaseQuantity(
    String userId,
    CartModel product,
  ) async {
    product.quantity++;

    await usersCollection
        .doc(userId)
        .collection('cart')
        .doc(product.id.toString())
        .update({
      'quantity': product.quantity,
    });

    emit(UpdateCartSuccessState());
  }

  Widget buildProductItem(ProductsModel model, BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          DetailsScreen.productsModel = model;
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: HomeCubit.get(context),
      child: const DetailsScreen(),
    ),
  ),
);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image(
                  image: NetworkImage("${model.images?[0]}"),
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
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      );
                    }
                  },
                ),
                InkWell(
                  onTap: () {
                    if (token != null) {
                      HomeCubit.get(context)
                          .toggleFavoriteProduct(token!, model);
                    }
                  },
                  child: model.in_favorites == true
                      ? const Icon(Iconsax.heart5)
                      : const Icon(Iconsax.heart),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 45.h,
              child: Text(
                '${model.name}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  color: HexColor("#1D1E20"),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
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
                Builder(
                  builder: (_) {
                    CartModel? cartItem = getCartItem(model.id);

                    if (cartItem == null) {
                      return InkWell(
                        onTap: () async {
                          if (token == null) return;

                          await addToCart(token!, model);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                  fontSize: 13),
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
                              await decreaseQuantity(token!, cartItem);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.remove,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                          Text(
                            "${cartItem.quantity}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () async {
                              await increaseQuantity(token!, cartItem);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget build_category_item(DataModel model, BuildContext context) {
    return InkWell(
      onTap: () async {
        EachCategoryScreen.id = model.id;
        EachCategoryScreen.name = model.name;
        EachCategoryScreen.slug = model.slug;

        final refresh = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const EachCategoryScreen(),
  ),
);

if (refresh == true) {
  HomeCubit.get(context).getHomeData();
}
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: HexColor("#F5F6FA"),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${model.name}',
          style: GoogleFonts.inter(
              color: HexColor("#1D1E20"),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
