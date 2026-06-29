import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectx_task_shopapp/features/profile/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/profile/cubit/states.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:connectx_task_shopapp/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ShopUpdateSuccessState) {
            Fluttertoast.showToast(
              msg: 'Profile updated successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          }
          if (state is ShopUpdateErrorState) {
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
          var cubit = ProfileCubit.get(context);
          var userModel = cubit.userModel;
          if (userModel == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          cubit.fillControllersFromUser();
          
          return ConditionalBuilder(
            // ignore: unnecessary_null_comparison
            condition: userModel!=null,
            fallback: (context) => const CircularProgressIndicator(),
            builder: (context) =>Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsetsDirectional.all(8),
                  child: CircleButton(
                    Iconsax.arrow_left,
                        () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                title: Text(
                  'Edit Profile',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: HexColor("#1D1E20"),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      cubit.updateUserData(
                          name: cubit.UserName_controller.text,
                          email: cubit.EmailController.text,
                          phone: cubit.PhoneController.text);
                    },
                    child: Text(
                      'UPDATE',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        color: Colors.blue[300],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is ShopUpdateLoadingstate)
                      const LinearProgressIndicator(),
                    if (state is ShopUpdateLoadingstate)
                      const SizedBox(
                        height: 10,
                      ),
                  
      
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //key: cubit.userkey,
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(IconBroken.User),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blue), // Change the color as needed
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius as needed
                        ),
                        label: Text(
                          'Username',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                        ),

                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      //key: cubit.userkey,
                      controller: cubit.EmailController,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: HexColor("#1D1E20"),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.message),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blue), // Change the color as needed
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius as needed
                        ),
                        label: Text(
                          'Email',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                        ),

                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: cubit.PhoneController,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: HexColor("#1D1E20"),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.call),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        label: Text(
                          'Phone',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: HexColor("#8F959E"),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ) ,

          );
        },
      );
    
  }
}
