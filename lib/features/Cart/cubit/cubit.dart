 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectx_task_shopapp/features/Cart/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CartModel/cart_model.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());

  static CartCubit get(context) => BlocProvider.of(context);

  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<CartModel> cartItems = [];

  double totalPrice = 0;

Future<void> getCart(String userId) async {
  emit(CartLoadingState());

  cartItems.clear();

  try {
    final value = await usersCollection
        .doc(userId)
        .collection('cart')
        .get();

    for (var element in value.docs) {
      cartItems.add(
        CartModel.fromJson(element.data()),
      );
    }

    calculateTotal();

    emit(CartSuccessState());
  } catch (error) {
    emit(CartErrorState(error.toString()));
  }
}


void calculateTotal() {
  totalPrice = cartItems.fold(
    0,
    (sum, item) => sum + item.totalPrice,
  );
}

Future<void> increaseQuantity(
    CartModel model,
    String userId,
) async {
  model.quantity++;

  await usersCollection
      .doc(userId)
      .collection('cart')
      .doc(model.id.toString())
      .update({
    'quantity': model.quantity,
  });

  calculateTotal();

  emit(IncreaseQuantityState());
}

Future<void> decreaseQuantity(
    CartModel model,
    String userId,
) async {
  if (model.quantity == 1) {
    removeFromCart(model, userId);
    return;
  }

  model.quantity--;

  await usersCollection
      .doc(userId)
      .collection('cart')
      .doc(model.id.toString())
      .update({
    'quantity': model.quantity,
  });

  calculateTotal();

  emit(DecreaseQuantityState());
}


Future<void> removeFromCart(
    CartModel model,
    String userId,
) async {
  await usersCollection
      .doc(userId)
      .collection('cart')
      .doc(model.id.toString())
      .delete();

  cartItems.removeWhere(
    (element) => element.id == model.id,
  );

  calculateTotal();

  emit(RemoveCartItemState());
}

Future<void> checkout(String userId) async {
  emit(CartLoadingState());

  final collection =
      usersCollection.doc(userId).collection('cart');

  final snapshot = await collection.get();

  for (var doc in snapshot.docs) {
    await doc.reference.delete();
  }

  cartItems.clear();
  calculateTotal();

  emit(CartSuccessState());
}
int get totalItems => cartItems.length;
bool get isCartEmpty => cartItems.isEmpty;
double get delivery => 10;
double get vat => totalPrice * .02;
double get finalPrice =>
    totalPrice + delivery + vat;
}