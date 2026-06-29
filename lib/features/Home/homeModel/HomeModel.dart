import 'package:connectx_task_shopapp/shared/component/component.dart';

class HomeModel {
  List<ProductsModel> products = [];

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      json['products'].forEach((element) {
        products.add(ProductsModel.fromJson(element));
      });
    }
  }
}