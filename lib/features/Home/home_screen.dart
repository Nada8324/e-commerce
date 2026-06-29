import 'package:connectx_task_shopapp/features/Home/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/states.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/cubit.dart';
import 'package:connectx_task_shopapp/shared/styles/icon_broken.dart';
import 'package:connectx_task_shopapp/features/allCategories/allCategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getHomeData()
        ..getCategories(),
      child: BlocConsumer<HomeCubit, HomeScreenStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var controller = HomeCubit.get(context);

          return ConditionalBuilder(
              condition: controller.homeModel != null,
              builder: (context) => Scaffold(
                    key: _scaffoldKey,
                    drawerEnableOpenDragGesture: false,
                    //backgroundColor: Colors.white,
                    //drawer: MenuScreen(),
                    // appBar: AppBar(
                    //
                    // ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 45.h,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                  child: CircleAvatar(
                                    radius: 22.5.r,
                                    backgroundColor: HexColor("#F5F6FA"),
                                    child: Icon(Icons.menu,
                                        color: HexColor("#1D1E20")),
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
                                    child: Icon(IconBroken.Bag,
                                        color: HexColor("#1D1E20")),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text('Hello',
                                style: GoogleFonts.inter(
                                    color: HexColor("#1D1E20"),
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600)),
                            Text('Welcome to Laza.',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  color: HexColor("#8F959E"),
                                )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: HexColor("#F5F6FA"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: controller.search_controller,
                                  onChanged: (value) {
                                    controller.search(value);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Search...",
                                      hintStyle: GoogleFonts.inter(
                                        color: HexColor("#8F959E"),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      isDense: true,
                                      prefixIcon: Icon(IconBroken.Search,
                                          color: HexColor('#8F959E'),
                                          size: 20.r),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Choose Category',
                                  style: GoogleFonts.inter(
                                    color: HexColor("#1D1E20"),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {},
                                  splashColor: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      AllCategoriesScreen.data =
                                          controller.categoryitemlist;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllCategoriesScreen(),
                                          ));
                                    },
                                    child: Text(
                                      'View All',
                                      style: GoogleFonts.inter(
                                        color: HexColor("#8F959E"),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            SizedBox(
                              height: 50.h,
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return controller.build_category_item(
                                      controller.categoryitemlist[index],
                                      context);
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10.sp,
                                  );
                                },
                                itemCount: controller.categoryitemlist.length,
                                // add length of list
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'New Arraival',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.sp,
                                      color: HexColor("#1D1E20")),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.white,
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 25.0.h,
                                crossAxisSpacing: 15.0.w,
                                childAspectRatio: 1 / 2,
                                crossAxisCount: 2,
                                children: List.generate(
                                    controller.search_controller.text.isEmpty
                                        ? controller.prductItemList.length
                                        : controller.searchProducts.length,
                                    (index) => controller.buildProductItem(
                                        controller
                                                .search_controller.text.isEmpty
                                            ? controller.prductItemList[index]
                                            : controller.searchProducts[index],
                                        context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
