import 'dart:ffi';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maching_learning/primary_button.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
// import 'package:flutter_beautiful_popup/main.dart';

class ResultData {
  String? result;
  String? accuracy;

  ResultData({this.result, this.accuracy});

  ResultData.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    accuracy = json['Accuracy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['accuracy'] = this.accuracy;
    return data;
  }
}

class PickImagePage extends StatefulWidget {
  const PickImagePage({Key? key}) : super(key: key);

  @override
  State<PickImagePage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImagePage> {
  Future<Future<String?>> getHttp(String b64Image) async {
    var response;
    try {
      var formData = FormData.fromMap({'img': b64Image});
      var ssresponse = await Dio().post(
          'https://db5e-2401-4900-1d77-b9ed-585b-147c-1844-740b.ngrok.io/api/uploader',
          data: formData);

      // Map<String, dynamic> result = jsonDecode(ssresponse);
      print(ssresponse);
      // print(result['Accuracy']);

      Map<String, dynamic> valueMap = json.decode(ssresponse.toString());

      ResultData output = ResultData.fromJson(valueMap);
      var acc = double.parse(output.accuracy.toString()).toStringAsFixed(3);
      print("Result: ${output.result} \nAccuracy: ${output.accuracy}");
      response = "Status: ${output.result} \nAccuracy: ${acc}";
    } catch (e) {
      response = "Error connecting to the server";
      print(e);
    }

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Result'),
        content: Text(response),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () => Navigator.pop(context, 'Cancel'),
          //   child: const Text('Cancel'),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String convertImage(dynamic file) {
    var bytes = Io.File(file.path).readAsBytesSync();

    String img64 = base64Encode(bytes);
    print("convertImage");
    print(img64);
    return img64;
  }

  Future<String?> PhotoError() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Result'),
        content: Text("ssss"),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () => Navigator.pop(context, 'Cancel'),
          //   child: const Text('Cancel'),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _filePath = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // final popup = BeautifulPopup(
    //   context: context,
    //   template: TemplateGift,
    // );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Text(
            "AI Assistant Doctor",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Center(
                  child: Text(
                "This is an AI prototype made by Maheir Kapadia in collaboration with Abd Kayali to aid in diagnosis of CT,MRI and X-Ray images with the main goal of reducing misdiagnosis.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "Take photo from a Camera",
                    showLoader: _isLoading,
                    onPressed: _takePhoto,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "Choose From Library",
                    showLoader: _isLoading,
                    onPressed: _chooseFromLibrary,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 290),
                    child: Center(
                      child: Text(
                        "Disclaimer:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Center(
                      child: Text(
                        "Disclaimer: The authors are not responsible if this AI is deployed in clinical settings as it is not FIELD TESTED",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _takePhoto() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      getHttp(convertImage(pickedFile));
    } else {
      PhotoError();
    }
  }

  void _chooseFromLibrary() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      getHttp(convertImage(pickedFile));
    } else {
      PhotoError();
    }
  }
}
