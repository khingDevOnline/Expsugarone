import 'package:expsugarone/utility/app_constant.dart';
import 'package:expsugarone/utility/app_controller.dart';
import 'package:expsugarone/utility/app_service.dart';
import 'package:expsugarone/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AreaListUser extends StatefulWidget {
  const AreaListUser({super.key});

  @override
  State<AreaListUser> createState() => _AreaListUserState();
}

class _AreaListUserState extends State<AreaListUser> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AppService().processReadAllArea();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => appController.areaModels.isEmpty
        ? const SizedBox()
        : ListView.builder( padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: appController.areaModels.length,
            itemBuilder: ((context, index) => Column( crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WidgetText(
                      data: appController.areaModels[index].nameArea,
                      textStyle: AppConstant().h2Style(),
                    ),
                    WidgetText(data: AppService().convertTimeTostring(timestamp: appController.areaModels[index].timestamp)),
                    const Divider(color: Colors.grey,),
                  ],
                ))));
  }
}
