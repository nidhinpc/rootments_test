import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:rootments_test/model/api_model.dart';

class HomeScreenController with ChangeNotifier {
  List<Apimodel?> dataList = [];

  Future getData() async {
    final url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxbG3Zrp8cuGmVMUtH3MB5JIOulR2nZ7dc81d67toYJNIupxuxjtdJAPGYmTgWs9dLT/exec?employeeId=TEST&email=nidhinpc66666@gmail.com");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        log(response.body);
        final jsonData = json.decode(response.body);
        final apimodel = Apimodel.fromJson(jsonData);

        // Update dataList and notify listeners
        dataList.clear();
        dataList.add(apimodel);
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}
