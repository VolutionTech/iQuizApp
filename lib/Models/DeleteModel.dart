import '../Services/BaseService.dart';

class DeleteModel extends JsonDeserializable<DeleteModel> {
  final String message;
  final bool success;

  DeleteModel({required this.message, required this.success});

  @override
  DeleteModel fromJson(Map<String, dynamic> json) {
    return DeleteModel(
      message: json['message'],
      success: json['success'],
    );
  }
}
