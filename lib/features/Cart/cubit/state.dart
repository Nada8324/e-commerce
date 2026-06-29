abstract class CartStates {}

class CartInitialState extends CartStates {}

class CartLoadingState extends CartStates {}

class CartSuccessState extends CartStates {}

class CartErrorState extends CartStates {
  final String error;

  CartErrorState(this.error);
}

class IncreaseQuantityState extends CartStates {}

class DecreaseQuantityState extends CartStates {}

class RemoveCartItemState extends CartStates {}