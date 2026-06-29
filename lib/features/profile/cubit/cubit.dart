
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Signup/UserModel/userdata.dart';
import 'package:connectx_task_shopapp/features/profile/cubit/states.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:connectx_task_shopapp/shared/network/local/cache_helper.dart';
import 'package:connectx_task_shopapp/shared/styles/icon_broken.dart';
import 'package:connectx_task_shopapp/features/StartScreen/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(GetUserInit());
  static ProfileCubit get(context) => BlocProvider.of(context);
  UserModel? userModel;

  var UserName_controller = TextEditingController();

  var EmailController = TextEditingController();
  var PhoneController = TextEditingController();
  bool controllersInitialized = false;

  void getuser() {
    if (token == null) {
      emit(GetUserError('Please log in again to view your profile.'));
      return;
    }
    emit(GetUserLoading());
    FirebaseFirestore.instance
        .collection('users')
        .doc(token)
        .get()
        .then((value) {
      userModel = UserModel.fromjson(value.data() ?? {});
      fillControllersFromUser();
      emit(GetUserSuccess());
    }).catchError((error) {
      emit(GetUserError(error.toString()));
      print(error.toString());
    });
  }

  void fillControllersFromUser() {
    if (controllersInitialized || userModel == null) return;
    UserName_controller.text = userModel!.name ?? '';
    EmailController.text = userModel!.email ?? '';
    PhoneController.text = userModel!.phone ?? '';
    controllersInitialized = true;
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopUpdateLoadingstate());
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .update(model.toMap())
        .then((value) {
      userModel = model;
      controllersInitialized = false;
      getuser();
      emit(ShopUpdateSuccessState());
    }).catchError((error) {
      emit(ShopUpdateErrorState('Profile update failed. Please try again.'));
    });
  }

  Future<void> resetPassword(String email) async {
    emit(ShopResetPasswordLoadingState());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );

      emit(ShopResetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
 

      emit(ShopResetPasswordErrorState(
        e.message ?? 'Something went wrong.',
      ));
    } catch (e) {
    

      emit(ShopResetPasswordErrorState(
        e.toString(),
      ));
    }
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0, left: 6, bottom: 8),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Iconsax.lock4,
                color: HexColor("#1D1E20"),
                size: 25,
              ),
              title: Text(
                "Reset Password",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: HexColor("#1D1E20")),
              ),
              onTap: () {
                resetPassword(userModel!.email!);
              },
            ),
            ListTile(
              leading: Icon(
                IconBroken.Bag,
                color: HexColor("#1D1E20"),
                size: 25,
              ),
              title: Text(
                "Order",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: HexColor("#1D1E20")),
              ),
              onTap: () {
                Shopcubit.get(context).changeindex(2);
              },
            ),
            ListTile(
              leading: Icon(
                Iconsax.wallet_2,
                color: HexColor("#1D1E20"),
                size: 25,
              ),
              title: Text(
                "My Cards",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: HexColor("#1D1E20")),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Iconsax.heart4,
                color: HexColor("#1D1E20"),
                size: 25,
              ),
              title: Text(
                "Wishlist",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: HexColor("#1D1E20")),
              ),
              onTap: () {
                Shopcubit.get(context).changeindex(1);
              },
            ),
            SizedBox(height: 40.h),
            ListTile(
              leading: Icon(
                IconBroken.Logout,
                color: HexColor("#FF5757"),
                size: 25.r,
              ),
              title: Text(
                "Logout",
                style: GoogleFonts.inter(
                    color: HexColor("#FF5757"),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () async {
  final shopCubit = Shopcubit.get(context);

  await CacheHelper.deleteToken(key: 'uId');
  token = null;

  shopCubit.changeindex(0);

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const SignupScreen(),
    ),
    (route) => false,
  );
},
            ),
          ],
        ),
      ),
    );
  }
}
