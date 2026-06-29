import '../shared/component/component.dart';

class EachCategoryModel {
  bool status = true;
  EachCategoryDataModel? data;

  EachCategoryModel.fromjson(Map<String, dynamic> json) {
    data = EachCategoryDataModel.fromjson(json);
  }
}

class EachCategoryDataModel {
  List<ProductsModel>? products = [];

  EachCategoryDataModel.fromjson(Map<String, dynamic> json) {
    final list = json['products'] as List? ?? json['data'] as List? ?? [];
    for (final element in list) {
      products?.add(ProductsModel.fromJson(element));
    }
  }
}
