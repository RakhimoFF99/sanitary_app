import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sanitary_pets/src/getx/auth.dart';
import 'package:sanitary_pets/src/getx/getLocale.dart';

import 'package:sanitary_pets/src/screens/Home/home_page.dart';

class LoginPage extends StatefulWidget {
   LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phone = TextEditingController();


  var auth = Get.put(Auth());
  var getLocale = Get.find<GetLocale>();

   var maskFormatter = new MaskTextInputFormatter(
       mask: '## ###-##-##',
       filter: { "#": RegExp(r'[0-9]') },
       type: MaskAutoCompletionType.lazy
   );

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();

      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width:size.width/1.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: Image.asset('assets/vet.png',fit: BoxFit.fill,),
                              ),

                              Container(
                                child: DropdownButton(
                                  hint: Text("lang".tr),
                                  onChanged: (value) {
                                      handleLangChange(value);
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: "uz",
                                      child: Text(
                                        "Uzbek",
                                      ),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: "kr",
                                      child: Text(
                                        "Kiril",
                                      ),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: "ru",
                                      child: Text(
                                        "Rus",
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),

                        SizedBox(height: 15,),
                        Container(
                          child: Text("topInfoText".tr,style: TextStyle(
                              fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),textAlign: TextAlign.center,),
                            )
                      ],
                    ),
                  ),
                  SizedBox(height: size.height/10,),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          inputFormatters: [maskFormatter],
                          controller: _phone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefix: Text('+998',style: TextStyle(
                              fontSize: 16
                            ),),
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 5)),
                           labelText: "labelPhone".tr,

                            prefixStyle: TextStyle(
                              color: Colors.black,

                            ),
                            labelStyle: TextStyle(

                                fontSize: 16
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          width: size.width/1.3,
                          height: 40,
                          child: ElevatedButton(onPressed: () {
                            print(_phone.text);
                            if(_phone.text.length == 12) {
                              return  savePhoneNumber(context);
                            }
                            EasyLoading.showError("Telefon raqamni to'gri kiriting");
                          }, child: Center(
                            child: Text("buttonEnter".tr,style: TextStyle(
                            fontWeight: FontWeight.w700,
                              fontSize: 16
                          ),),)))

                    ],
                  ),
                  Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleLangChange (value) {
    if(value == 'uz') {
      getLocale.setLocale(value);

    }
    else if (value == 'kr') {
      getLocale.setLocale(value);

    }
    else if (value == 'ru' ) {
      getLocale.setLocale(value);

    }

  }
  savePhoneNumber (context) async{
   await auth.setPhone(_phone.text);


  }
}
