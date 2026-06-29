import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectx_task_shopapp/features/Editprofile/EditProfileScreen.dart';
import 'package:connectx_task_shopapp/features/profile/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/profile/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';


class ProfileScreen extends StatelessWidget {
   const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return  BlocConsumer<ProfileCubit,ProfileStates>(
         listener: (context, state) {
          if(state is ShopResetPasswordSuccessState){
                Fluttertoast.showToast(
                    msg:'Password reset email sent. Check your inbox.',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              if(state is ShopResetPasswordErrorState){
                Fluttertoast.showToast(
                    msg:state.error,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
         },
         builder: (context, state) {
           var userModel=ProfileCubit.get(context).userModel;
           return ConditionalBuilder(
             condition: userModel!=null,
             builder:(context) => Scaffold(
               appBar: AppBar(
                 backgroundColor: Colors.white,
                 title: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(
                     'Profile',
                     style: GoogleFonts.inter(
                       fontWeight: FontWeight.w800,
                       fontSize: 20.sp,
                       color: HexColor("#1D1E20"),
                     ),
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                   ),
                 ),
               ),
                 body: SingleChildScrollView(
                   child: Padding(
                     padding: const EdgeInsetsDirectional.all(10),
                     child: Column(
                       children: [
                         const CircleAvatar (
                                 radius: 65,
                                 backgroundColor: Colors.white,
                                 child: CircleAvatar(
                                   radius: 60,
                                   
                                   backgroundImage: AssetImage("assets/images/user.jpg"),
                                 ),
                               ),
                         const SizedBox(
                           height: 5,
                         ),
                         Row(
                           children: [
                             Text(
                               'Name: ',
                               style: GoogleFonts.inter(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 20.sp,
                                 color: HexColor("#1D1E20"),
                               ),
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(width: 10,),
                             Text(
                               '${userModel?.name}',
                               style: GoogleFonts.inter(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 20.sp,
                                 color: HexColor("#1D1E20"),
                               ),
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                           ],
                         ),
                         const SizedBox(
                           height:5,
                         ),
                         Row(
                           children: [
                             Text(
                               'Email: ',
                               style: GoogleFonts.inter(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 20.sp,
                                 color: HexColor("#1D1E20"),
                               ),
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(width: 10,),
                             Text(
                               '${userModel?.email}',
                               style: GoogleFonts.inter(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 18.sp,
                                 color: HexColor("#1D1E20"),
                               ),
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                             ),
                           ],
                         ),
                         const SizedBox(
                           height:5,
                         ),
                         Row(
                           children: [
                             Text(
                               'Phone: ',
                               style: GoogleFonts.inter(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 20.sp,
                                 color: HexColor("#1D1E20"),
                               ),
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(width: 10,),
                             Text(
                               '${userModel?.phone}',
                               style: GoogleFonts.inter(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 20.sp,
                                 color: HexColor("#1D1E20"),
                               ),
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                           ],
                         ),
                         const SizedBox(
                           height:5,
                         ),
                         InkWell(
                           onTap: () {
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: ProfileCubit.get(context),
      child: const EditProfileScreen(),
    ),
  ),
);                           },
                           child: Container(
                             height: 40,
                             width: double.infinity,

                             decoration: BoxDecoration(
                                 color: Colors.blue[100],
                                 borderRadius: BorderRadius.circular(4)

                             ),
                             child: const Center(child: Text("Edit Profile")),
                           ),
                         ),
                         //ProfileCubit.get(context).buildUserInfo(context),
                         ProfileCubit.get(context).buildMenuItems(context)
                       ],
                     ),
                   ),
                 )
               // add like design in menu screen and functions in profile controller
             ),
             fallback: (context) => const Center(child: CircularProgressIndicator()),
           );
         },
       );
     
  }
}

