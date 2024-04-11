import 'package:shared_preferences/shared_preferences.dart';

import '../Application/url.dart';
import '../Models/ReportModel.dart';
import 'BaseService.dart';

class ReportService extends BaseService {
  Future<ReportModel?> report({required String message}) async {
    try {
      ReportModel instance = ReportModel(message: 'message', success: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? phone = prefs.getString('phone');

      var data = await super.request<ReportModel>(
          endPoint: reportEndPoint,
          type: RequestType.post,
          instance: instance,
          body: {'message': message, 'phone': phone ?? ''});

      return data;
    } catch (error) {
      return null;
    }
  }
}
