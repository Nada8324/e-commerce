
abstract class ShopCategoryStates{}
class ShopCategoryInitialState extends ShopCategoryStates{}

class ShopCategoryLoadingState extends ShopCategoryStates{}

class ShopCategorySuccessState extends ShopCategoryStates
{
}

class ShopCategoryErrorState extends ShopCategoryStates
{
  final String error;
  ShopCategoryErrorState(this.error);
}
class RemoveFromWishList extends ShopCategoryStates{}

class DeatilsAddToWishList extends ShopCategoryStates{

}
class DetailsToogleLoading extends ShopCategoryStates{}
