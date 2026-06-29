import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectx_task_shopapp/features/Details/DetailsScreen.dart';
import 'package:connectx_task_shopapp/features/Favourite/cubit/state.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/cubit.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:connectx_task_shopapp/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';

class FavCubit extends Cubit<FavStates>{

  static FavCubit get(context) =>BlocProvider.of(context);

  FavCubit():super(favinit());
  bool done=false;
  void getdata()async{
    emit(favLoadData());
    ListOfFavorite=[];
    await getFavoriteProducts(token!);
    done=true;
    emit(getdataf());
  }
  final CollectionReference<Map<String, dynamic>> usersCollection =
  FirebaseFirestore.instance.collection('users');
  Future<void> toggleFavoriteProduct(String userId, ProductsModel product) async {
    final favoriteDoc = await usersCollection.doc(userId).collection('favorites').doc(product.id.toString()).get();
    emit(favload());
    if (favoriteDoc.exists) {
      product.in_favorites=false;
      await usersCollection.doc(userId).collection('favorites').doc(product.id.toString()).delete();
      emit(favsuccess());
    } else {
      product.in_favorites=true;

      await usersCollection.doc(userId).collection('favorites').doc(product.id.toString()).set(product.toMap());
      emit(favsuccess());
    }
  }

List<ProductsModel> product_list_deleted=[];
Widget BuildFavItem(ProductsModel productsModel,BuildContext context) {
  return Dismissible(
    direction: DismissDirection.endToStart,
    key: Key(productsModel.id.toString()),
    onDismissed: (direction){
      FavCubit.get(context).toggleFavoriteProduct(token!,productsModel);
      for (var element in ListOfFavorite) {
        if(element.id==productsModel.id)
        {

        }
        else{
          product_list_deleted.add(element);
          FavCubit.get(context).toggleFavoriteProduct(token.toString(), productsModel);
        }
      }
      emit(favchange());
      ListOfFavorite=product_list_deleted;

      //update();
    },

    background: Container(
      width: double.infinity,
      color: Colors.white,
      child: const Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(Iconsax.heart_remove),
      ),
    ),
    child: Container(
      height: 120.h,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 20.r,

            offset: const Offset(4, 8), // Shadow position
          ),
        ],
        color: HexColor("#FEFEFE"),
      ),

      child: InkWell(
        onTap: () {
          DetailsScreen.productsModel=productsModel;
          Navigator.push(
            context,
           MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: HomeCubit.get(context),
      child: const DetailsScreen(),
    ),
  ),
          );
        },
        child: Row(

          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 100.w,
              //height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r)
              ),
              child: Image(image: NetworkImage(productsModel.images![0]!),

                //fit: BoxFit.scaleDown,
                loadingBuilder:(context, child, loadingProgress)  {
                  if(loadingProgress==null){
                    return child;
                  }
                  else{
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }
                },),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h,),
                    SizedBox(
                      width: 137.w,
                      child: Text(
                       productsModel.name!,
                        style:GoogleFonts.inter(
                          color:  HexColor("#1D1E20"),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,),
                    ),
                    const Spacer(),
                    //SizedBox(height: 20.h,),
                    Row(
                      children: [
                        Text('\$${productsModel.price}(+${(productsModel.price*0.02).round()} Tax)',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp,
                              color: HexColor("#8F959E"),
                            )),
                        const Spacer(),
                        InkWell(
                          child: Container(
                            width: 25.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                    color: HexColor("#DEDEDE")
                                )
                            ),
                            child: Icon(IconBroken.Delete,size: 15,color: HexColor("#8F959E")),

                          ),
                          onTap: () {
                            FavCubit.get(context).toggleFavoriteProduct(token.toString(), productsModel);
                            ListOfFavorite.remove(productsModel);

                          },
                        )
                      ],
                    ),
                    SizedBox(height: 6.h,)
                  ],

                ),
              ),
            ),
            // Icon(IconBroken.Bookmark)

          ],

        ),

      ),
    ),
  );
}
}