import 'package:expsugarone/utility/app_controller.dart';
import 'package:expsugarone/utility/app_service.dart';
import 'package:expsugarone/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyProfile extends StatefulWidget {
  const BodyProfile({super.key});

  @override
  State<BodyProfile> createState() => _BodyProfileState();
}

class _BodyProfileState extends State<BodyProfile> {
  AppController appController = Get.put(AppController());
  AppService appService = Get.put(AppService());

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
    
    WidgetText(data: ' appService.value.name'));
  }
}
