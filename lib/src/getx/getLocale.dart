import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocale extends GetxController {

  var locale ;
  @override
  void onInit () {
      getLocale();
      super.onInit();


  }
  
  getLocale() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var data = await prefs.getString('locale');
   print(data);
   if(data is String) {
     locale = data;
   }

  }
  
  setLocale (locale) async {
    try {  
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('locale', locale);
      Get.updateLocale(Locale(locale));
    } 
    catch(e) {
      print(e);
    }
      
  }
}