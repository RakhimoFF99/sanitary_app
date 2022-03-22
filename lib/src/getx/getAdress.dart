import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sanitary_pets/src/service/api.dart';

class GetAdress extends GetxController {
  var region = [].obs;
  var districts = [].obs;
  Dio dio = Dio();

  @override
  onInit() {
    super.onInit();
    getRegion();
  }

  Future getRegion() async {
    var res = await dio.get("$baseUrl/reports/getregion");
    region.value = res.data;
  }

  Future getDistrict(id) async {
    var res = await dio.get("$baseUrl/reports/getdistrict?id=$id");
    this.districts.value = res.data;
  }
}
