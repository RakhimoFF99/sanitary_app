import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sanitary_pets/src/service/api.dart';

class GetAdress extends GetxController {
  var region = [].obs;
  var districts = [].obs;
  var qfi = [].obs;
  Dio dio = Dio();
  var regionId ;
  var districtId ;
  var qfyId;

  @override
  onInit() async{
    super.onInit();
   await getRegion();
  }

  Future getRegion() async {
    try {
      var res = await dio.get("$baseUrl/reports/getregion");

      print(res.data);
      if(res.statusCode == 200) {
        region.value = res.data;
      }

    }
    catch(e) {
      print(e);
    }

  }

  Future getDistrict(region) async {
    this.regionId = region['region_id'];
  try {
    var res = await dio.get("$baseUrl/reports/getdistrict?id=$regionId");
    if(res.statusCode == 200) {
      this.districts.value = res.data;
    }
  }
  catch(e) {
    print(e);
  }
  }

  Future getQfi (districtId) async{
    try {
      var res = await dio.get("$baseUrl/reports/getqfi?id=$districtId&regid=$regionId");
    this.qfi.value = res.data;}
    catch(e) {
      print(e);

    }

  }
}
