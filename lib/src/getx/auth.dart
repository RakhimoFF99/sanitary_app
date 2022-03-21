
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends GetxController {
 var isAuthed = false.obs;
 var phone = "".obs;
  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }
  checkAuth () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

   var data = await prefs.getString('phone');
   phone.value = data.toString();
    if(data is String) {
      isAuthed.value = true;
    }

  }
  setPhone (number) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', number);
    phone.value = number;
    isAuthed.value = true;
  }

  removePhone () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAuthed.value = false;
    prefs.remove('phone');


  }
}