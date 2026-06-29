import 'package:connectx_task_shopapp/features/Cart/cart_screen.dart';
import 'package:connectx_task_shopapp/features/Favourite/Favorite_Screen.dart';
import 'package:connectx_task_shopapp/features/Home/home_screen.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/states.dart';
import 'package:connectx_task_shopapp/features/profile/profile_screen.dart';
import 'package:connectx_task_shopapp/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class Shopcubit extends Cubit<ShopState>
{
  Shopcubit():super(ShopInitState());

  static Shopcubit get(context) =>BlocProvider.of(context);
  int index=0;

  List<Widget> widget=[HomeScreen(),const FavoriteScreen(),const CartScreen(),const ProfileScreen()];
  void changeindex(int value){
    index=value;
    emit(ShopChangeIndex());
  }

  Widget buildbottom(){
    return  BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      currentIndex: index,
      onTap: (value) {
       changeindex(value);
      },
      selectedItemColor: HexColor("#4A4E69"),
      unselectedItemColor: HexColor("#8F959E"),
      backgroundColor: HexColor("#FEFEFE"),
      selectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedLabelStyle:  const TextStyle(color: Colors.grey),
      selectedFontSize: 0,

      items: [
        BottomNavigationBarItem(icon: index!=0?const Icon(IconBroken.Home)
            :const Text("Home"),
            label: ''
        ),
        BottomNavigationBarItem(icon: index!=1?const Icon(IconBroken.Heart):
        const Text("Favorite"),
            label: ''),
        BottomNavigationBarItem(icon: index!=2?const Icon(IconBroken.Bag):
        const Text("Cart"),
            label:""),
        BottomNavigationBarItem(icon: index!=3?const Icon(IconBroken.Profile):
        const Text("Profile"),
            label:""),
      ],
    );
  }
}