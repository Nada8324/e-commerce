
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectx_task_shopapp/features/Favourite/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Favourite/cubit/state.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/cubit.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';

import '../../shared/styles/icon_broken.dart';

class FavoriteScreen extends StatelessWidget {
   const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavCubit()..getdata(),

      child: BlocConsumer<FavCubit,FavStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return ConditionalBuilder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Shopcubit.get(context).changeindex(0);
                              //controller.changeindex(0);
                              // اللي هو ارجع اللهوم changeindex(0)  هنادي علي فانكشن
                            },
                            child: CircleAvatar(
                              radius: 22.5.r,
                              backgroundColor: HexColor("#F5F6FA"),
                              child: Icon(Iconsax.arrow_left, color: HexColor("#1D1E20")),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Shopcubit.get(context).changeindex(2);
                  
                            },
                            child: CircleAvatar(
                              radius: 22.5.r,
                              backgroundColor: HexColor("#F5F6FA"),
                              child: Icon(IconBroken.Bag, color: HexColor("#1D1E20")),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        '${ListOfFavorite.length} Items',
                        style: GoogleFonts.inter(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: HexColor("#1D1E20"),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'in wishlist',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: HexColor("#8F959E"),
                        ),
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: SizedBox(

                          width: double.infinity,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                  
                            itemCount: ListOfFavorite.length,
                  
                  
                            itemBuilder: (context, index) => FavCubit.get(context).BuildFavItem(ListOfFavorite[index],context),
                  
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15.h,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap:true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            condition: FavCubit.get(context).done,
            fallback: (context) =>const Center(child: CircularProgressIndicator(),) ,

          );
        },

      ),
    );
  }

}
