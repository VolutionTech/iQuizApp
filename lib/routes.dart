import 'package:get/get.dart';
import 'login.dart';


appRoutes() => [
  GetPage(
    name: '/login',
    page: () => Login(),
    transition: Transition.leftToRightWithFade,
    transitionDuration: const Duration(milliseconds: 500),
  ),

];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print(page?.name);
    return super.onPageCalled(page);
  }
}