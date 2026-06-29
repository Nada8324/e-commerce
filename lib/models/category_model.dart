class CategoryModel {
  bool? status;
  CategoryDetails? data;

  CategoryModel.Fromjson(dynamic json) {
    status = true;
    data = CategoryDetails.Fromjson(json);
  }
}

class CategoryDetails {
  int? current_page;
  List<DataModel>? data = [];

  CategoryDetails.Fromjson(dynamic json) {
    final categories = json is List ? json : json['data'] as List? ?? [];
    for (var i = 0; i < categories.length; i++) {
      data?.add(DataModel.Fromjson(categories[i], i));
    }
  }
}

class DataModel {
  int? id;
  String? name;
  String? slug;


  DataModel.Fromjson(dynamic json, [int? index]) {
    id = json is Map<String, dynamic> ? json['id'] ?? index : index;
    slug =
        json is Map<String, dynamic> ? json['slug'] ?? json['name'] : json.toString();
    name = json is Map<String, dynamic>
        ? json['name'] ?? slug
        : _formatCategoryName(slug ?? '');
  }
}

String _formatCategoryName(String value) {
  return value
      .split('-')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
