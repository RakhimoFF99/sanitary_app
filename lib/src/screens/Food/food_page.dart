import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();



}

class _FoodState extends State<Food> {

  var region;
  var district;
  var condition;
  var animal;
  List <String> animals = ["It","Mushuk","Ot"];
  List <String> conditions = ["Yaxshi","Yomon","Juda yomon","O'lik","Tirik"];
  List <String> _regions = ["Toshkent","Samarqand","Xorazm","Navoiy","Buxoro"];
  List <String> _districts = ["Xiva","Xonqa","Yangibozor","Navoiy","Buxoro"];



  var files = [];

  Widget buildGridView(file) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: GridView.count(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 7,
        children: List.generate(
            file.length, (index){
          if(file[index] is PickedFile){
            print(file[index]);
            return Image.file(File(file[index].path));
          }
          return Container();

        }),

      ),
    );
  }



  loadAssets() async {
    var resultList;
    try {
      resultList = await ImagePicker().getMultiImage(
          imageQuality: 60, maxWidth: 800, maxHeight: 600);
      if (resultList.length > 3) {
        resultList.removeRange(3, resultList.length);
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
                        SizedBox(height: 30,),
                        Text("Kasallikni tegishli tashkilotga jo'natish uchun formani to'ldiring",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                        ),textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        Text("Xabar qiluvchi shaxs",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(height: 10,),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 5)),
                                labelText: "Ism".tr,
                                prefixStyle: TextStyle(
                                    color: Colors.black
                                ),
                                labelStyle: TextStyle(
                                    fontSize: 16
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 5)),
                                labelText: "Familiya".tr,
                                prefixStyle: TextStyle(
                                    color: Colors.black
                                ),
                                labelStyle: TextStyle(
                                    fontSize: 16
                                )
                            ),
                          ),
                        ),


                        SizedBox(height: 20,),
                        Text("Xayvon",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(height: 15,),
                        Padding(

                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.3)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: size.height/13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.animal,
                                borderRadius: BorderRadius.circular(10),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),

                                hint: Text("Xayvonni turi".tr),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(new FocusNode());///It will clear all focus of the textfield
                                  setState(() {
                                    this.animal = value.toString();
                                  });
                                },
                                items: this.animals.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.3)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: size.height/13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.condition,
                                borderRadius: BorderRadius.circular(10),

                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),

                                hint: Text("Xayvonni xolati".tr),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(new FocusNode());///It will clear all focus of the textfield
                                  setState(() {
                                    this.condition = value.toString();
                                  });
                                },
                                items: this.conditions.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 18,horizontal: 10),
                                border: OutlineInputBorder(),
                                labelText: "Xayvon xaqida qo'shimcha malumot"
                            ),
                            maxLines: null,

                          ),
                        ),

                        SizedBox(height: 15,),
                        Text("Manzil",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        ),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.3,)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: size.height/13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.region,
                                borderRadius: BorderRadius.circular(10),

                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),

                                hint: Text("Viloyat".tr),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(new FocusNode());///It will clear all focus of the textfield
                                  setState(() {
                                    this.region = value.toString();
                                  });
                                },
                                items: this._regions.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.3)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: size.height/13,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: this.district,
                                borderRadius: BorderRadius.circular(10),

                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),

                                hint: Text("Tuman".tr),
                                onChanged: (value) {
                                  FocusScope.of(context).requestFocus(new FocusNode());///It will clear all focus of the textfield
                                  setState(() {
                                    this.district = value.toString();
                                  });
                                },
                                items: this._districts.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("Rasm",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(height: 15),
                        files.length > 0 ? buildGridView(files): Container(),
                        SizedBox(height: 15,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(onPressed: () {
                              loadAssets();
                            },
                                child: Text("Rasm yuklash",style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700
                                ),))),

                        SizedBox(height: 20,),



                      ]),
                ),
              ))),
    );
  }
}