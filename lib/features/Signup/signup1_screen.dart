import 'package:connectx_task_shopapp/features/LoginScreen/login_screen.dart';
import 'package:connectx_task_shopapp/features/Signup/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Signup/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../shared/component/component.dart';

class Signup1Screen extends StatelessWidget {
  const Signup1Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegosterCubit(),
      child: BlocConsumer<ShopRegosterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopCreateUserSuccessState) {
            Fluttertoast.showToast(
              msg: 'Account created successfully. Please log in.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          }
          if (state is ShopRegisterErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
          if (state is ShopCreateUserErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<ShopRegosterCubit>(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: cubit.formkey,
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
                          'Sign Up',
                          style: GoogleFonts.inter(
                            color: HexColor("#1D1E20"),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90.h,
                      ),
                      TextFormField(
                        key: cubit.userkey,
                        controller: cubit.UserName_controller,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'User name is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          cubit.suffixicon_user(cubit.userkey);
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Username',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#8F959E"),
                            ),
                          ),
                          suffixIcon: cubit.suffix_user,
                          suffixIconColor: HexColor("#4A4E69"),
                          suffixStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        key: cubit.emailKey,
                        controller: cubit.Email_controller,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                        validator: Validators.compose([
                          Validators.required('Email address is required'),
                          Validators.email('Please enter a valid email address')
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          cubit.suffixicon_email(cubit.emailKey);
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Email Address',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#8F959E"),
                            ),
                          ),
                          suffixIcon: cubit.suffix_email,
                          suffixIconColor: HexColor("#4A4E69"),
                          suffixStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        key: cubit.password,
                        controller: cubit.Password_controller,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                        validator: Validators.compose([
                          Validators.required('Password is required'),
                          Validators.patternString(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                            'Password must be 8+ chars with uppercase, lowercase, number, and symbol',
                          )
                        ]),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cubit.ispassword,
                        onChanged: (value) {
                          cubit.suffixicon_pass(cubit.password);
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Password',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: HexColor("#8F959E"),
                            ),
                          ),
                          suffixText: cubit.suffix_pass,
                          suffixIcon: IconButton(
                            icon: Icon(cubit.suffix),
                            onPressed: cubit.Visibaltypassword,
                          ),
                          suffixIconColor: HexColor("#4A4E69"),
                          suffixStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: cubit.Phone_controller,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                        validator: Validators.compose([
                          Validators.required('Phone number is required'),
                        ]),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          label: Text(
                            'Phone number',
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
                      SizedBox(
                        height: 90.h,
                      ),
                      Center(
                        child: InkWell(
                          onTap: state is ShopRegisterLoadingState
                              ? null
                              : () async {
                                  if (cubit.formkey.currentState!.validate()) {
                                    cubit.userdata(
                                        username:
                                            cubit.UserName_controller.text,
                                        password:
                                            cubit.Password_controller.text,
                                        email: cubit.Email_controller.text,
                                        phone: cubit.Phone_controller.text,
                                        image: 'sss');
                                  }
                                },
                          child: Container(
                            width: 107.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: HexColor("#4A4E69"),
                            ),
                            child: Center(
                              child: Text(
                                state is ShopRegisterLoadingState
                                    ? "Loading..."
                                    : "Sign up",
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
