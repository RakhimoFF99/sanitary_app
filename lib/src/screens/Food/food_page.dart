import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/multipart_file.dart' as Multipart;
import 'package:dio/src/form_data.dart' as FormData;
import 'package:http_parser/http_parser.dart';
import 'package:sanitary_pets/src/getx/auth.dart';
import 'package:sanitary_pets/src/getx/getAdress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sanitary_pets/src/getx/getLocale.dart';
import 'package:sanitary_pets/src/service/api.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  var region;
  var district;
  var qfi;
  var condition;
  var conditionId;
  var food;

  var conditions = [];
  var getAdress = Get.find<GetAdress>();
  var files = [];

  Dio dio = Dio();
  var position;

  var auth = Get.find<Auth>();
  var locale = Get.find<GetLocale>();

  TextEditingController _detail = TextEditingController();



  @override
  initState() {
    super.initState();
    getAdress.districts.value = [];
    getAdress.districtId = null;
    getAdress.regionId = null;
    getAdress.qfyId = null;
    getAdress.qfi.value = [];
    getAdress.foodById.value = [];
    getAdress.values.value = [];
    getFoodCondition();
    _determinePosition();
  }

  Widget buildGridView(file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.count(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 7,
        children: List.generate(file.length, (index) {
          if (file[index] is PickedFile) {

            return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Image.file(File(file[index].path)));
          }
          return Container();
        }),
      ),
    );
  }

  loadAssets() async {
    var resultList;
    try {
      resultList = await ImagePicker()
          .getMultiImage(imageQuality: 60, maxWidth: 800, maxHeight: 600);
      if (resultList.length > 6) {
        resultList.removeRange(6, resultList.length);
      }
    } on Exception catch (e) {

    }

    setState(() {
      files = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Ovqat'.tr),
            elevation: 0,
          ),
          body: SafeArea(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Ovqatni tegishli tashkilotga jo'natish uchun formani to'ldiring",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Ovqat",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GetX<GetAdress>(
                        init: GetAdress(),
                        builder: (controller) {
                          return Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.3)),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: size.height / 13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.food,
                                borderRadius: BorderRadius.circular(10),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                hint: Text("Ovqat turi".tr),
                                onChanged: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  ///It will clear all focus of the textfield
                                  setState(() {
                                    getAdress.foodById.value = [];
                                    getAdress.values.value = [];
                                    this.food = value;

                                    getAdress.getFoodById(value);
                                  });
                                },
                                items: controller.food.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value['name']),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    GetX<GetAdress>(
                      init: GetAdress(),
                      builder: (controller) {
                        return Column(children: [

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15,),

                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.foodById.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.3)),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      height: size.height / 13,
                                      width: double.infinity,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            value: controller.values[index],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            hint: Text("Ovqat turi"),
                                            onChanged: (value) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());

                                              ///It will clear all focus of the textfield
                                              setState(() {
                                                getAdress.clearChild(index);
                                                controller.values[index] = value;
                                                getAdress.getFoodById(value);
                                              });
                                            },
                                            items: controller.foodById[index]
                                                .map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value['name']),
                                              );
                                            }).toList()),
                                      ));
                                }),
                          ),

                        ]);
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.3)),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: size.height / 13,
                        width: double.infinity,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: this.condition,
                            borderRadius: BorderRadius.circular(10),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            hint: Text("Ovqat xolati".tr),
                            onChanged: (value) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              ///It will clear all focus of the textfield
                              setState(() {
                                this.condition = value;
                                selectedCat(value);
                              });
                            },
                            items: this.conditions.map(( value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value['name_uz']),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 10),
                            border: OutlineInputBorder(),
                            labelText: "Xayvon xaqida qo'shimcha malumot"),
                        maxLines: null,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Manzil",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GetX<GetAdress>(
                        init: GetAdress(),
                        builder: (controller) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 0.3,
                            )),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: size.height / 13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.region,
                                borderRadius: BorderRadius.circular(10),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                hint: Text("Viloyat".tr),
                                onChanged: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  setState(() {
                                    getAdress.districts.value = [];
                                    this.district = null;
                                    getAdress.getDistrict(value);
                                    this.region = value ?? ['name_lot'];
                                  });
                                },
                                items: controller.region.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value['name_lot']),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GetX<GetAdress>(
                        init: GetAdress(),
                        builder: (controller) {
                          return Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.3)),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: size.height / 13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.district,
                                borderRadius: BorderRadius.circular(10),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                hint: Text("Tuman".tr),
                                onChanged: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  ///It will clear all focus of the textfield
                                  setState(() {
                                    this.district = value ?? ['name_lot'];
                                    getAdress.getQfi(value);
                                    this.qfi = null;
                                  });
                                },
                                items: controller.districts.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value['name_lot']),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GetX<GetAdress>(
                        init: GetAdress(),
                        builder: (controller) {
                          return Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.3)),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: size.height / 13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.qfi,
                                borderRadius: BorderRadius.circular(10),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                hint: Text("Qishloq".tr),
                                onChanged: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  ///It will clear all focus of the textfield
                                  setState(() {
                                    this.qfi = value;
                                    getAdress.setQfi(value);
                                  });
                                },
                                items: controller.qfi.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value['name_lot']),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Rasm",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    files.length > 0 ? buildGridView(files) : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              loadAssets();
                            },
                            child: Text(
                              "Rasm yuklash",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ))),

                    SizedBox(height: 10,),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () async{
                             if(conditionId == null && getAdress.foodId == null) {
                               EasyLoading.showError("Ovqat turi va xolatini to'ldiring");
                          ;
                             }
                            else if(getAdress.qfyId == null) {
                               EasyLoading.showError("Manzilni to'liq to'ldiring to'ldiring");

                             }
                            else if(files.length == 0) {
                               EasyLoading.showError("Rasm yuklang !");

                             }
                            else {
                               await _determinePosition();
                               position == null ? EasyLoading.showError("Joylashuvni olishga ruxsat bering"):sendImage();
                             }

                            },
                            child: Text(
                              "Malumotlarni yuklash",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ))),
    );
  }


  Future sendImage() async {

    EasyLoading.show();
    var images = [];
    for (var i = 0; i < files.length; i++) {
      var multipartFile = await Multipart.MultipartFile.fromFile(
          files[i].path,
          contentType: MediaType("image", "jpg"));
      images.add(multipartFile);
    }

    var formData = FormData.FormData.fromMap({
      "image[]":images
    });
    try {
      var response = await dio.post("$baseUrl/reports/setimage",data: formData);
      if(response.statusCode == 200) {
        print(response.data);
        sendAllData(response.data);
      }
    }
    catch(e) {

      EasyLoading.showError("Xatolik yuz berdi");
    }
  }


    selectedCat (value) {
      setState(() {
        conditionId = value['id'];
      });
    }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var location =    await Geolocator.getCurrentPosition();
    position = location;
    return location;

  }


  Future getFoodCondition() async {
    try {
      var res = await dio.get("$baseUrl/reports/getfoodcategory");
      EasyLoading.dismiss();

      if (res.statusCode == 200) {
        setState(() {
          conditions = res.data;
        });
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  Future sendAllData (image) async{
    var phone = auth.phone.split('');
    for(var i = 0; i<phone.length; i++) {
      if(phone[i] == " "||phone[i] == "-") {
        phone.removeAt(i);
      }
    }

    Map data  = {
      "type_id":getAdress.foodId,
      "cat_id":conditionId,
      "detail":_detail.text,
      "lat":position.latitude,
      "long":position.longitude,
      "phone":"998" + phone.join(),
      "lang":locale.locale.toString(),
      "soato_id":getAdress.qfyId,
      "image":image

    } ;
  print(data);

    try {
      var response = await dio.post("$baseUrl/reports/createfood",data: data);
      if(response.statusCode == 200) {
        EasyLoading.showSuccess("Xabaringiz qabul qilindi tez orada ko'rib chiqiladi natija sms xabar qilinadi");
        Navigator.pop(context);
      }
    }
    catch(e) {
      EasyLoading.showError("Xatolik yuz berdi");
    }
  }



}
