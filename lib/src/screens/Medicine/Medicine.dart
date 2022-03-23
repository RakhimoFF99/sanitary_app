import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanitary_pets/src/getx/auth.dart';
import 'package:sanitary_pets/src/getx/getLocale.dart';
import 'package:dio/src/multipart_file.dart' as Multipart;
import 'package:dio/src/form_data.dart' as FormData;
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sanitary_pets/src/service/api.dart';
import 'package:sanitary_pets/src/getx/getAdress.dart';

class Medicine extends StatefulWidget {
  Medicine({Key? key}) : super(key: key);

  @override
  State<Medicine> createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  var medicine;
  var condition;
  var region;
  var district;
  var qfi;
  var medicineTypeId;
  var medicineConditionId;
  var position;

  List medicines = [];
  List conditions = [];

  var files = [];

  Dio dio = Dio();

  var getAdress = Get.find<GetAdress>();
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
    getMedicineType();
    getMedicineCondition();
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
            print(file[index]);
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
      print(e.toString());
    }
    print(resultList);
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
          title: Text("Dori-darmon"),
          elevation: 0,
        ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Dori-darmon tegishli tashkilotga jo'natish uchun formani to'ldiring",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.3)),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: size.height / 13,
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: this.medicine,
                      borderRadius: BorderRadius.circular(10),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      hint: Text("Dori turi".tr),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        ///It will clear all focus of the textfield
                        setState(() {
                          this.medicine = value;
                          setMedicineType(value);
                        });
                      },
                      items: this.medicines.map((value) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.3)),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: size.height / 13,
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: this.condition,
                      borderRadius: BorderRadius.circular(10),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      hint: Text("Dori xolati".tr),
                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        ///It will clear all focus of the textfield
                        setState(() {
                          this.condition = value;
                          setMedicineCondition(value);
                        });
                      },
                      items: this.conditions.map((value) {
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
                  controller: _detail,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                      border: OutlineInputBorder(),
                      labelText: "Dori xaqida qo'shimcha malumot"),
                  maxLines: null,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Manzil",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
                      decoration: BoxDecoration(border: Border.all(width: 0.3)),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: size.height / 13,
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: this.district,
                          borderRadius: BorderRadius.circular(10),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          hint: Text("Tuman".tr),
                          onChanged: (value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            ///It will clear all focus of the textfield
                            setState(() {
                              this.district = value ?? ['name_lot'];
                              getAdress.getQfi(value ?? ['district_id']);
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
                      decoration: BoxDecoration(border: Border.all(width: 0.3)),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: size.height / 13,
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: this.qfi,
                          borderRadius: BorderRadius.circular(10),
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                          onPressed: () {
                            sendImage();
                          },
                          child: Text(
                            "Malumotlarni yuborish",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ))),


              SizedBox(
                height: 20,
              ),
            ]),
          ),
        )),
      ),
    );
  }
  setMedicineType (value) {
      setState(() {
          medicineTypeId = value['id'];
      });
  }
  setMedicineCondition (value) {
      setState(() {
       medicineConditionId = value['id'];
           });
  }


  Future getMedicineType() async {
    EasyLoading.show();
    try {
      var res = await dio.get("$baseUrl/reports/getdrugtype");
      if (res.statusCode == 200) {
        setState(() {
          medicines = res.data;
        });
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  Future getMedicineCondition() async {
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
        sendAllData(response.data);
      }
    }
    catch(e) {
      print(e);
      EasyLoading.dismiss();
    }
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

  Future sendAllData (image) async{
    var phone = auth.phone.split('');
    for(var i = 0; i<phone.length; i++) {
      if(phone[i] == " "||phone[i] == "-") {
        phone.removeAt(i);
      }
    }

    Map data  = {
      "type_id":medicineTypeId,
      "cat_id":medicineConditionId,
      "detail":_detail.text,
      "lat":position.latitude,
      "long":position.longitude,
      "phone":"998" + phone.join(),
      "lang":locale.locale.toString(),
      "soato_id":getAdress.qfyId,
      "image":image

    } ;


    try {
      var response = await dio.post("$baseUrl/reports/createdrug",data: data);
      if(response.statusCode == 200) {
        EasyLoading.showSuccess('Malumotlar yuklandi');
        Navigator.pop(context);
      }
    }
    catch(e) {
      EasyLoading.dismiss();
    }
  }



}
