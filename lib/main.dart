
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sanitary_pets/src/getx/LocaleString.dart';
import 'package:sanitary_pets/src/getx/auth.dart';
import 'package:sanitary_pets/src/getx/getLocale.dart';
import 'package:sanitary_pets/src/screens/Home/home_page.dart';
import 'package:sanitary_pets/src/screens/Login/login_page.dart';





void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(GetLocale());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(
        new MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    final getLocale = Get.find<GetLocale>();
    EasyLoading.instance..backgroundColor = Colors.blue;
    return GetMaterialApp(
      title: 'VIS-Sayyor',
      translations: LocaleString(),
      locale: getLocale.locale is String ? Locale(getLocale.locale) : Locale('uz'),
      builder: EasyLoading.init(
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: InkSplash.splashFactory,
        primarySwatch: Colors.blue,
      ),
      home: GetX<Auth>(
        init: Auth(),
        builder: (controller) {
          return controller.isAuthed.isTrue ? HomePage() : LoginPage();
        },
      ),
    );
  }
}

