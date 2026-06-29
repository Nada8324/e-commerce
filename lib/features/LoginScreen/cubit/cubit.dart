import 'package:connectx_task_shopapp/features/LoginScreen/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{
  ShopLoginCubit():super(ShopLoginInitialState());
  
  static ShopLoginCubit get(context)=>BlocProvider.of(context);
  String ?uId;
  var Password_controller=TextEditingController();
  var Email_controller=TextEditingController();
  var formkey=GlobalKey<FormState>();
  var password=GlobalKey<FormFieldState>();
  var emailKey=GlobalKey<FormFieldState>();
  Widget suffix_email=const Icon(Icons.unpublished_outlined);

  bool status = false;
  IconData suffix=Icons.visibility_outlined;
  bool ispassword=true;
  Future<void> userdata ({
    required String password,
    required String email,
  }) async {
    emit(ShopLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      emit(ShopLoginSuccessState(value.user!.uid));
     
      uId=value.user?.uid;
    }).catchError((error){
      emit(ShopLoginErrorState(_firebaseAuthErrorMessage(error)));
    });
  }
  Future<void> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      emit(ShopResetPasswordErrorState('Enter your email first, then tap forgot password.'));
      return;
    }
    emit(ShopResetPasswordLoadingState());
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.trim())
        .then((value) {
      emit(ShopResetPasswordSuccessState());
    }).catchError((error) {
      emit(ShopResetPasswordErrorState(_firebaseAuthErrorMessage(error)));
    });
  }
  void Visibaltypassword()
  {
    ispassword=!ispassword;
    suffix=ispassword? Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
  void ChangeValueOfSwitch(bool value){
    status=value;
    emit(ShopLoginSwitchFalse());

  }
  void suffixicon_email(GlobalKey<FormFieldState> key) {
    if (key.currentState!.validate()){
      suffix_email=const Icon(Icons.check);
    }
    else{
      suffix_email= const Icon(Icons.unpublished_outlined);
    }
    emit(ShopLoginChangeEmailIconState());
  }
}

String _firebaseAuthErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return error.message ?? 'Something went wrong. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}
