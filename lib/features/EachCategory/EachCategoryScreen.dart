import 'package:connectx_task_shopapp/features/EachCategory/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/EachCategory/cubit/states.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import '../../shared/styles/icon_broken.dart';

class EachCategoryScreen extends StatelessWidget {
  static int? id;
  static String? name;
  static String? slug;
  static String? image;
  const EachCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getCategoryProduct(),
      child: BlocConsumer<CategoryCubit, ShopCategoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // var LayoutController = Shopcubit.get(context);
          var controller = CategoryCubit.get(context);
          return PopScope(
               canPop: false,
            
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
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
                          onTap: () async {
                            Navigator.pop(context, true);
                          },
                          child: CircleAvatar(
                            radius: 22.5.r,
                            backgroundColor: HexColor("#F5F6FA"),
                            child: Icon(Iconsax.arrow_left,
                                color: HexColor("#1D1E20")),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                            Shopcubit.get(context).changeindex(2);
                          },
                          child: CircleAvatar(
                            radius: 22.5.r,
                            backgroundColor: HexColor("#F5F6FA"),
                            child: Icon(IconBroken.Bag,
                                color: HexColor("#1D1E20")),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text('$name',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                          color: Colors.black,
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    if (controller.Model == null)
                      const Expanded(
                          child: Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )),
                    if (controller.Model != null)
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: GridView.count(
                            shrinkWrap: true,
                            mainAxisSpacing: 17.0.h,
                            crossAxisSpacing: 15.0.w,
                            childAspectRatio: 1 / 2,
                            crossAxisCount: 2,
                            children: List.generate(
                              controller.products.length,
                              (index) => controller.BuildProductItem(
                                controller.products[index],
                                context,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
