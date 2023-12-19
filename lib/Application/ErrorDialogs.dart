import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

showConfirmationDialog(String title, String msg, String confirmText,
    String cancelText, Function onConfirm, Function onCancel) {
  var context = Get.context;
  if (context != null) {
    Dialogs.materialDialog(
      msg: msg,
      title: title,
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            onCancel();
            Get.back();
          },
          text: cancelText,
          color: Colors.grey, // Customize this color as needed
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            onConfirm();
            Get.back();
          },
          text: confirmText,
          color: Colors.red, // Customize this color as needed
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }
}
