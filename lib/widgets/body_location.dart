import 'dart:io';

import 'package:expsugarone/utility/app_controller.dart';
import 'package:expsugarone/utility/app_dialog.dart';
import 'package:expsugarone/utility/app_service.dart';
import 'package:expsugarone/widgets/widget_button.dart';
import 'package:expsugarone/widgets/widget_form.dart';
import 'package:expsugarone/widgets/widget_icon_button.dart';
import 'package:expsugarone/widgets/widget_image_asset.dart';
import 'package:expsugarone/widgets/widget_map.dart';
import 'package:expsugarone/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BodyLocation extends StatefulWidget {
  const BodyLocation({super.key});

  @override
  State<BodyLocation> createState() => _BodyLocationState();
}

class _BodyLocationState extends State<BodyLocation> {
  AppController appController = Get.put(AppController());
  var latlng = <LatLng>[];

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    appController.displaySave.value = false;
    appController.displayAddMarker.value = true;

    if (appController.mapMakers.isNotEmpty) {
      appController.mapMakers.clear();
    }

    if (appController.setPolygons.isNotEmpty) {
      appController.setPolygons.clear();
    }

    AppService().processFindLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => appController.positions.isEmpty
          ? const SizedBox()
          : SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  WidgetMap(
                    lat: appController.positions.last.latitude,
                    lng: appController.positions.last.longitude,
                    myLocationEnable: true,
                  ),
                  Positioned(
                    top: 26,
                    left: 26,
                    child: Column(
                      children: [
                        Obx(() => appController.displayAddMarker.value
                            ? WidgetIconButton(
                                iconData: Icons.add_box,
                                pressFunc: () async {
                                  AppService()
                                      .processFindLocation()
                                      .then((value) {
                                    print(appController.positions.last
                                        .toString());

                                    latlng.add(LatLng(
                                      appController.positions.last.latitude,
                                      appController.positions.last.longitude,
                                    ));

                                    MarkerId markerId = MarkerId(
                                        'id${appController.mapMakers.length}');
                                    Marker marker = Marker(
                                        markerId: markerId,
                                        position: LatLng(
                                          appController.positions.last.latitude,
                                          appController
                                              .positions.last.longitude,
                                        ));

                                    appController.mapMakers[markerId] = marker;
                                  });
                                },
                                size: GFSize.LARGE,
                                gfButtonType: GFButtonType.outline,
                              )
                            : const SizedBox()),
                        const SizedBox(
                          height: 8,
                        ),
                        Obx(() => appController.mapMakers.length >= 3
                            ? WidgetIconButton(
                                iconData: Icons.select_all,
                                pressFunc: () {
                                  appController.displayAddMarker.value = false;
                                  print(
                                      'ขนาดของจุด maerker --> ${latlng.length}');

                                  appController.setPolygons.add(Polygon(
                                    polygonId: const PolygonId('id'),
                                    points: latlng,
                                    fillColor: Colors.red.withOpacity(0.2),
                                    strokeColor: Colors.red.shade800,
                                    strokeWidth: 2,
                                  ));
                                  appController.mapMakers.clear();

                                  appController.displaySave.value = true;

                                  setState(() {});
                                },
                                size: GFSize.LARGE,
                                gfButtonType: GFButtonType.outline,
                              )
                            : const SizedBox()),
                        Obx(
                          () => appController.displaySave.value
                              ? WidgetIconButton(
                                  iconData: Icons.save,
                                  size: GFSize.LARGE,
                                  gfButtonType: GFButtonType.outline,
                                  pressFunc: () {
                                    AppDialog().normalDailog(
                                      title: 'คุณต้องการบันทึก',
                                      contentWidget: Form(
                                        key: formKey, 
                                        child: WidgetForm( textEditingController: nameController,
                                          validatorFunc: (p0) { 
                                            if (p0?.isEmpty ?? true) {
                                              return 'โปรดกรอกข้อมูลพื้นที่';
                                            } else {
                                              return null;
                                            }
                                          },
                                          labelWidget: const WidgetText(
                                              data: 'ชื่อพื้นที่ :'),
                                        ),
                                      ),
                                      firstWidget: WidgetButton(
                                        label: 'บันทึก',
                                        pressFunc: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            Get.back();
                                            AppService().processSaveArea(
                                                nameArea: nameController.text,
                                                latlngs: latlng);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
