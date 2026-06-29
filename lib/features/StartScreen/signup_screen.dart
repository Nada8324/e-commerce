import 'package:connectx_task_shopapp/features/Signup/signup1_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';


import '../LoginScreen/login_screen.dart';

class SignupScreen extends StatelessWidget {
   const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 96.h,
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text('Shopzen',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color:HexColor("#4A4E69")),
                  ),
                ),
                SizedBox(
                  height: 28.h,
                ),
                Image(image: const AssetImage("assets/images/onboarding1.png"),
                  height:361.h ,
                  width: 468.w,),
                SizedBox(
                  height: 22.h,
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text('Get Your Stuffs',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color:HexColor("#090A0A")),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text('Here!',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color:HexColor("#090A0A")),
                  ),
                ),
                SizedBox(
                  height: 37.h,
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: InkWell(
                    onTap: () {
                      //  Get.to(()=>Signup1Screen());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup1Screen()),
                      );
                    },
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      width: 191.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: HexColor("#4A4E69"),

                      ),
                      child: Text("Create account"
                        ,style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color:Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an account?',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color:HexColor("#202325")),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text('Log in',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color:HexColor("#4A4E69")),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );

  }
}
