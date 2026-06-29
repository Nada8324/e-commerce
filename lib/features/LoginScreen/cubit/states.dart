
abstract class ShopLoginStates{}
class ShopLoginInitialState extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates{}

class ShopLoginSuccessState extends ShopLoginStates
{
  final String uId;
  ShopLoginSuccessState(this.uId);
}

class ShopLoginErrorState extends ShopLoginStates
{
  final String error;
  ShopLoginErrorState(this.error);
}
class ShopChangePasswordVisibilityState extends ShopLoginStates{}

class ShopLoginSwitchTrue extends ShopLoginStates{}

class ShopLoginSwitchFalse extends ShopLoginStates{}

class ShopLoginChangePasswordIconState extends ShopLoginStates{}

class ShopLoginChangeEmailIconState extends ShopLoginStates{}

class ShopResetPasswordLoadingState extends ShopLoginStates{}

class ShopResetPasswordSuccessState extends ShopLoginStates{}

class ShopResetPasswordErrorState extends ShopLoginStates
{
  final String error;
  ShopResetPasswordErrorState(this.error);
}
