abstract class ProfileStates{}

class GetUserInit extends ProfileStates{}

class GetUserLoading extends ProfileStates{}

class GetUserSuccess extends ProfileStates{}

class GetUserError extends ProfileStates{
  final String error;
  GetUserError( this.error);
}

class ShopUpdateLoadingstate extends ProfileStates{}

class ShopUpdateSuccessState extends ProfileStates{}

class ShopUpdateErrorState extends ProfileStates{
  final String error;
  ShopUpdateErrorState(this.error);
}
class ShopResetPasswordLoadingState extends ProfileStates{}

class ShopResetPasswordSuccessState extends ProfileStates{}

class ShopResetPasswordErrorState extends ProfileStates
{
  final String error;
  ShopResetPasswordErrorState(this.error);
}
