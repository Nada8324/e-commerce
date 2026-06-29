abstract class ShopRegisterStates{}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSuccessState extends ShopRegisterStates{
  final String uId;
  ShopRegisterSuccessState(this.uId);
}

class ShopRegisterErrorState extends ShopRegisterStates
{
  final String error;
  ShopRegisterErrorState(this.error);
}

class ShopCreateUserSuccessState extends ShopRegisterStates{

}

class ShopCreateUserErrorState extends ShopRegisterStates
{
  final String error;
  ShopCreateUserErrorState(this.error);
}

class ShopRegisterChangeUserIconState extends ShopRegisterStates{}

class ShopRegisterChangePasswordIconState extends ShopRegisterStates{}

class ShopRegisterChangeEmailIconState extends ShopRegisterStates{}

class ShopRegisterChangeEyeIconState extends ShopRegisterStates{}

class ShopRegisterSwitchTrue extends ShopRegisterStates{}

class ShopRegisterSwitchFalse extends ShopRegisterStates{}

class ShopRegisterChangeSwitch extends ShopRegisterStates{}


