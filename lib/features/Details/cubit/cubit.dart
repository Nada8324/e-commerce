import 'package:connectx_task_shopapp/features/Details/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsCubit extends Cubit<Details>{
  DetailsCubit():super(init());
  static Details get(context) =>BlocProvider.of(context);

  /*final CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('cart');
*/
/*  Future<void> addToCart(String productId, String productName, double price,
      int quantity) async {
    emit(load());
    try {
      final existingItem =
      await cartCollection.doc(productId).get();

      if (existingItem.exists) {
        final int newQuantity =(existingItem.data() as Map<String, dynamic>?)?['quantity'] ?? 0 + quantity;

        await cartCollection.doc(productId).update({'quantity': newQuantity});
      } else {
        // If the item doesn't exist, add it to the cart
        await cartCollection.doc(productId).set({
          'productName': productName,
          'price': price,
          'quantity': quantity,
        });
      }
      emit(success());
    } catch (error) {
      // Handle errors
      print('Error adding to cart: $error');
      throw error;
    }
  }*/

}