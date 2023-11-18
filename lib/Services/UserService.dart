import '../Application/url.dart';
import '../Models/LoginResponseModel.dart';
import 'BaseService.dart';

class UserServices extends BaseService {


  Future<UserLoginResponse?> loginUser(String phoneNumber) async {
   try {
     Map<String, dynamic> requestBody = {
       "phone": phoneNumber,
       "role": "user"
     };
     return await request<UserLoginResponse>(
       endPoint: userEndPoint,
       type: RequestType.post,
       instance: UserLoginResponse(success: false, token: '', user: User.fromJson({}), message: ''),
       body: requestBody,
     );
   } catch (error) {
     print('Error: $error');
     throw Exception('Failed to load data');
   }

  }

  Future<UserLoginResponse?> getUserData(Function success) async {
   try {
     var user = await request<UserLoginResponse>(
        endPoint: userEndPoint+'getUser',
        type: RequestType.get,
        instance: UserLoginResponse(success: false, token: '', user: User.fromJson({}), message: ''),
      );
     success(user);
      return user;
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }

  }


  Future<UserLoginResponse?> saveProfile(String name, String image) async {
    final String apiUrl = '$baseURL$userEndPoint';

    try {
      Map<String, dynamic> data =  {
        "name": name,
        "imageName": image,
      };
      return await request<UserLoginResponse>(
        endPoint: userEndPoint,
        type: RequestType.put,
        instance: UserLoginResponse(success: false, token: '', user: User.fromJson({}), message: ''),
        body: data,
      );
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load data');
    }

  }

}