import 'package:get/get.dart';
import 'package:imm_quiz_flutter/DBhandler/DBhandler.dart';

class QuizAppController extends GetxController {

  RxList attempted = [].obs;
  RxMap maxIndexCategory = {}.obs;

  double getPercentage(category)  {
    var result = maxIndexCategory;
    if (result == null || result.isEmpty) { return 0.0; }
    var currIndex = result['ind'] + 1;
    var total = result['total'];
    return currIndex / total;
  }
  updateData(category) async {
    // var dbHandler = DatabaseHandler();
    // var resultMap = await dbHandler.getRowWithMaxIndForCategory(category);
    // if (resultMap != null) {
    //   this.maxIndexCategory = RxMap.from(resultMap);
    // }
    // var resultMap2 = await dbHandler.getAllItems(category);
    //     attempted = [].obs;
    //     resultMap2.forEach((element) {
    //       attempted.add(element);
    //     });
  }


}