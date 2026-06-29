import 'package:connectx_task_shopapp/features/Layout/Layout_screen.dart';
import 'package:connectx_task_shopapp/features/LoginScreen/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/LoginScreen/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';

import 'package:wc_form_validators/wc_form_validators.dart';

import '../../shared/component/component.dart';
import '../../shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) async {
          if (state is ShopLoginErrorState) {
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is ShopResetPasswordSuccessState) {
            Fluttertoast.showToast(
                msg: 'Password reset email sent. Check your inbox.',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is ShopResetPasswordErrorState) {
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is ShopLoginSuccessState) {
            Fluttertoast.showToast(
              msg: "login Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            token = state.uId;

            await CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            );
                                                                                                                                       
           Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => const LayoutScreen(),
  ),
  (route) => false,
);
          }
        },
        builder: (context, state) {
          var controller = BlocProvider.of<ShopLoginCubit>(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: controller.formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45.h,
                      ),
                      CircleButton(Iconsax.arrow_left, () {
                        Navigator.pop(context);
                      }),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Welcome',
                          style: GoogleFonts.inter(
                            color: HexColor("#1D1E20"),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Please enter your data to continue',
                          style: GoogleFonts.inter(
                            color: HexColor("#8F959E"),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90.h,
                      ),
                      TextFormField(
                        key: controller.emailKey,
                        controller: controller.Email_controller,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                        validator: Validators.compose([
                          Validators.required('Email address is required'),
                          Validators.email('Please enter a valid email address')
                        ]),
                        onChanged: (value) {
                          controller.suffixicon_email(controller.emailKey);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffixIcon: controller.suffix_email,
                          suffixIconColor: HexColor("#4A4E69"),
                          suffixStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                          label: Text(
                            'Email Address',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#8F959E"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        key: controller.password,
                        controller: controller.Password_controller,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: controller.ispassword,
                        validator: Validators.compose([
                          Validators.required('Password is required'),
                        ]),
                        decoration: InputDecoration(
                          label: Text(
                            'Password',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#8F959E"),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(controller.suffix),
                            onPressed: controller.Visibaltypassword,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: TextButton(
                          onPressed: () {
                            if (controller.emailKey.currentState?.validate() ??
                                false) {
                              controller.resetPassword(
                                  controller.Email_controller.text);
                            }
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.deepPurple[200],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Remember me',
                            style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w500,
                                color: HexColor("#1D1E20"),
                                fontSize: 13),
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            height: 18.h,
                            width: 30.w,
                            padding: 0.0,
                            toggleSize: 18.0,
                            borderRadius: 10.0,
                            activeColor: HexColor("#4A4E69"),
                            value: controller.status,
                            onToggle: (value) {
                              controller.ChangeValueOfSwitch(value);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 65.h,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'By connecting your account confirm that you',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: HexColor("#8F959E"),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'agree with our Term and Condition',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: HexColor("#8F959E"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (controller.formkey.currentState!.validate()) {
                              controller.userdata(
                                  password: controller.Password_controller.text,
                                  email: controller.Email_controller.text);
                            }
                          },
                          child: Container(
                            width: 94.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: HexColor("#4A4E69"),
                            ),
                            child: Center(
                              child: Text(
                                "Log in",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
