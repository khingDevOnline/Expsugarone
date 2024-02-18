import 'package:expsugarone/models/area_model.dart';
import 'package:expsugarone/states/qr_reader.dart';
import 'package:expsugarone/utility/app_constant.dart';
import 'package:expsugarone/utility/app_controller.dart';
import 'package:expsugarone/utility/app_dialog.dart';
import 'package:expsugarone/utility/app_service.dart';
import 'package:expsugarone/widgets/widget_button.dart';
import 'package:expsugarone/widgets/widget_map.dart';
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
        : SizedBox(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: appController.areaModels.length,
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            print('You Tap index -->$index');
                            dispalyDialog(
                                areaModel: appController.areaModels[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              WidgetText(
                                data: appController.areaModels[index].nameArea,
                                textStyle: AppConstant().h2Style(),
                              ),
                              WidgetText(
                                  data: AppService().convertTimeTostring(
                                      timestamp: appController
                                          .areaModels[index].timestamp)),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ))),
                Positioned(bottom: 16, right: 16,
                  child: WidgetButton( 
                    label: 'Qr Reader',
                    pressFunc: () {

                        Get.to(QRreader());

                    },
                  ),
                )
              ],
            ),
          ));
  }

  void dispalyDialog({required AreaModel areaModel}) {
    AppDialog().normalDailog(
        title: 'รายละเอียด',
        contentWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 200,
                height: 180,
                child: WidgetMap(
                  lat: areaModel.geoPoint.last.latitude,
                  lng: areaModel.geoPoint.last.longitude,
                )),
            WidgetText(data: 'QRCode -->${areaModel.qrCode}'),
          ],
        ));
  }
}
