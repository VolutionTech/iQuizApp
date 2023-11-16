
import '../Models/CategoryModel.dart';

class DataCacheManager {
  static DataCacheManager? _instance;

  DataCacheManager._();

  factory DataCacheManager() {
    _instance ??= DataCacheManager._();
    return _instance!;
  }

  List<Category>? category;
  var headerToken = "";

}