// import 'dart:ffi';  // Not used import?
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
  String? accuracy_smaller;
  String? accuracy_bigger;

  ResultData({this.result, this.accuracy_smaller,this.accuracy_bigger});

  ResultData.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    accuracy_smaller = json['Accuracy_Smaller'];
    accuracy_bigger = json['Accuracy_Bigger'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['accuracy_smaller'] = this.accuracy_smaller;
    data['accuracy_bigger'] = this.accuracy_bigger;
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
    // Added clear api path and to change link on the fly
    // Change this link to your host server where Ai is being hosted
    String link = "Link to your host"; 
    String api = "/api/uploader";
    String url = link + api;
    try {
      var formData = FormData.fromMap({'img': b64Image});
      var ssresponse = await Dio().post(url, data: formData);

      // Map<String, dynamic> result = jsonDecode(ssresponse);
      print(ssresponse);
      // print(result['Accuracy']);

      Map<String, dynamic> valueMap = json.decode(ssresponse.toString());

      ResultData output = ResultData.fromJson(valueMap);
      var acc_s = double.parse(output.accuracy_smaller.toString()).toStringAsFixed(3);
      var acc_b = double.parse(output.accuracy_bigger.toString()).toStringAsFixed(3);
      print("Result: ${output.result} \nAccuracy: ${output.accuracy_smaller}");
      response = "Status: ${output.result} \n Accuracy_Smaller: ${acc_s}\n Accuracy_Bigger: ${acc_b}";
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
        content: const Text("ERROR no photo uploaded!"),
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
              color: Colors.blue,
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
                        "The authors are not responsible if this AI is deployed in clinical settings as it is not FIELD TESTED",
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
