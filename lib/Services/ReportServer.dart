import 'package:firebase_auth/firebase_auth.dart';

import '../Application/url.dart';
import '../Models/ReportModel.dart';
import 'BaseService.dart';

class ReportService extends BaseService {
  Future<ReportModel?> report({required String message}) async {
    try {
      ReportModel instance = ReportModel(message: 'message', success: false);
      var phone = await FirebaseAuth.instance.currentUser?.phoneNumber;
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
