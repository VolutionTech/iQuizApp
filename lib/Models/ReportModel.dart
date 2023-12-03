import '../Services/BaseService.dart';

class ReportModel extends JsonDeserializable<ReportModel> {
  final String message;
  final bool success;

  ReportModel({required this.message, required this.success});

  @override
  ReportModel fromJson(Map<String, dynamic> json) {
    return ReportModel(
      message: json['message'],
      success: json['success'],
    );
  }
}
