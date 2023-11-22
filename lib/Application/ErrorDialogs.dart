import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

showErrorDialog(String msg) {
  var context = Get.context;
  if (context != null) {
    Dialogs.materialDialog(
        msg: msg,
        title: "Network Error",
        color: Colors.white,
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Get.back();
            },
            text: 'Ok',
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}