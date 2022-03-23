import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sanitary_pets/src/service/api.dart';

class GetAdress extends GetxController {
  var region = [].obs;
  var districts = [].obs;
  var food = [].obs;
  var foodById = <List>[].obs;
  var foodId;
  var qfi = [].obs;
  Dio dio = Dio();
  var regionId;
  var districtId;
  var values = [].obs;
  var qfyId;


  @override
  onInit() async {
    super.onInit();
    await getRegion();
    await getAllFoodType();
  }

  Future getRegion() async {
    try {
      var res = await dio.get("$baseUrl/reports/getregion");

      if (res.statusCode == 200) {
        region.value = res.data;
      }
    } catch (e) {
      print(e);
    }
  }

  Future getAllFoodType() async {
    EasyLoading.show();
    try {
      var res = await dio.get("$baseUrl/reports/getfoodtype");
      if (res.statusCode == 200) {
        food.value = res.data;
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }


  clearChild (index) {
    if(index + 1 != null) {
      foodById.removeRange(index + 1, foodById.length);
      values.removeRange(index + 1 ,foodById.length);
    }

  }
  Future getFoodById(value) async {
    var id = value['id'];
    EasyLoading.show();

    try {
      var res = await dio.get("$baseUrl/reports/getfoodtype?id=$id");
      EasyLoading.dismiss();
      if (res.statusCode == 200) {
        if(res.data is String) {
            foodId = res.data;
        }
        if(res.data is List) {
          print(res.data);
          values.add(null);
          foodById.add(res.data);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  Future getDistrict(region) async {
    EasyLoading.show();
    this.regionId = region['region_id'];
    try {
      var res = await dio.get("$baseUrl/reports/getdistrict?id=$regionId");
      EasyLoading.dismiss();
      if (res.statusCode == 200) {
        this.districts.value = res.data;
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  Future getQfi(districtId) async {
    EasyLoading.show();
    var id = districtId['district_id'];

    try {
      var res = await dio.get("$baseUrl/reports/getqfi?id=$id&regid=$regionId");
      EasyLoading.dismiss();
      this.qfi.value = res.data;
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  setQfi(qfi) {
    this.qfyId = qfi['MHOBT_cod'];
  }
}