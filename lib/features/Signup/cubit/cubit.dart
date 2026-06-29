/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../models/userdata.dart';
import '../shared/component/component.dart';
import '../shared/network/end_points.dart';
import '../shared/network/remote/diohelper.dart';
import '../view/login_screen.dart';

class SignUpController extends GetxController{
  var UserName_controller=TextEditingController();
  var Password_controller=TextEditingController();
  var Email_controller=TextEditingController();
  var Phone_controller=TextEditingController();
  bool get=false;
  var formkey=GlobalKey<FormState>();
  var password=GlobalKey<FormFieldState>();
  var emailKey=GlobalKey<FormFieldState>();
  var userkey=GlobalKey<FormFieldState>();
  UserModel ?model;
   String suffix_pass='weak';
  Widget suffix_user=Icon(Icons.unpublished_outlined);
  Widget suffix_email=Icon(Icons.unpublished_outlined);
  bool status = false;
  Future<void> userdata ({
    required String username,
    required String password,
    required String email,
    required String phone,
    required String image,
}) async {
   await DioHelper.postData(url: Register, data: {
     'name':username,
      'email':email,
      'password':password,
      'phone':phone,
     'image':image
    }).then((value) {
      print("ndhkdjlkjkljcldjsldlsklsld          kdjkdl.kfdls");
      model=UserModel.fromjson(value?.data);
      print(model?.status);
      print(model?.message);
      print(model?.data);

      update();
    });
  }
  void suffixicon_user(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()){
      suffix_user=Icon(Icons.check);
    }
    else{
      suffix_user= Icon(Icons.unpublished_outlined);
    }
    update();
  }
  void suffixicon_pass(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()) {
      suffix_pass = 'Strong';
    }
    else{
      suffix_pass='weak';
    }
    update();
  }
  void suffixicon_email(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()){
      suffix_email=Icon(Icons.check);

    }
    else{
      suffix_email= Icon(Icons.unpublished_outlined);
    }
    update();
  }
}
*/
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectx_task_shopapp/features/Signup/UserModel/userdata.dart';
import 'package:connectx_task_shopapp/features/Signup/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ShopRegosterCubit extends Cubit<ShopRegisterStates> {
  ShopRegosterCubit() : super(ShopRegisterInitialState());

  var UserName_controller=TextEditingController();
  var Password_controller=TextEditingController();
  var Email_controller=TextEditingController();
  var Phone_controller=TextEditingController();
  bool get=false;
  bool ispassword =true;
  IconData suffix=Icons.visibility_outlined;
  var formkey=GlobalKey<FormState>();
  var password=GlobalKey<FormFieldState>();
  var emailKey=GlobalKey<FormFieldState>();
  var userkey=GlobalKey<FormFieldState>();
  bool status=true;
  UserModel ?model;
  String suffix_pass='weak';
  Widget suffix_user=const Icon(Icons.unpublished_outlined);
  Widget suffix_email=const Icon(Icons.unpublished_outlined);
  Future<void> userdata ({
    required String username,
    required String password,
    required String email,
    required String phone,
    required String image,
  }) async {
    emit(ShopRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      CreateUser(
          username: username,
          email: email,
          phone: phone,
          uId: value.user!.uid,
          image:"https://i.pinimg.com/736x/96/5a/33/965a33cf28be7e31250b6b87f1409a89.jpg",
          coverimage: "https://i.pinimg.com/736x/96/5a/33/965a33cf28be7e31250b6b87f1409a89.jpg"
      );
      emit(ShopRegisterSuccessState(value.user!.uid));


    }).catchError((error){
      emit(ShopRegisterErrorState(_firebaseAuthErrorMessage(error)));
    });
  }

  void CreateUser ({
    required String username,
    required String email,
    required String phone,
    required String uId,
    required String image,
    required String coverimage,
  })
  {
    UserModel model=UserModel(
      name: username,
      email: email,
      phone: phone,
      uId: uId,
   
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {

          emit(ShopCreateUserSuccessState());

        }).catchError((error){
          emit(ShopCreateUserErrorState('Account created, but saving profile failed. Please try again.'));
    });
  }
  
  void suffixicon_user(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()){
      suffix_user=const Icon(Icons.check);
    }
    else{
      suffix_user= const Icon(Icons.unpublished_outlined);
    }
    emit(ShopRegisterChangeUserIconState());
  }
  void suffixicon_pass(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()) {
      suffix_pass = 'Strong';
    }
    else{
      suffix_pass='weak';
    }
    emit(ShopRegisterChangePasswordIconState());
  }
  void suffixicon_email(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()){
      suffix_email=const Icon(Icons.check);

    }
    else{
      suffix_email= const Icon(Icons.unpublished_outlined);
    }
    emit(ShopRegisterChangeEmailIconState());
  }

  void Visibaltypassword()
  {
    ispassword=!ispassword;
    suffix=ispassword? Icons.visibility_outlined:Icons.visibility_off_outlined;
  emit(ShopRegisterChangeEyeIconState());
  }
  void ChangeValueOfSwitch(bool value){
      status=value;
 /*   if(status=true)*/
      emit(ShopRegisterSwitchTrue());
   /* else
      emit(ShopRegisterSwitchFalse());*/
  }

}

String _firebaseAuthErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters with uppercase, lowercase, number, and symbol.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return error.message ?? 'Could not create account. Please try again.';
    }
  }
  return 'Could not create account. Please try again.';
}
