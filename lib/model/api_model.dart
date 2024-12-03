// To parse this JSON data, do
//
//     final apimodel = apimodelFromJson(jsonString);

import 'dart:convert';

Apimodel apimodelFromJson(String str) => Apimodel.fromJson(json.decode(str));

String apimodelToJson(Apimodel data) => json.encode(data.toJson());

class Apimodel {
  bool? success;
  Data? data;

  Apimodel({
    this.success,
    this.data,
  });

  factory Apimodel.fromJson(Map<String, dynamic> json) => Apimodel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  String? no;
  String? employeeId;
  String? employeeName;
  String? branchName;
  String? designation;
  String? emailId;
  String? locCode;

  Data({
    this.no,
    this.employeeId,
    this.employeeName,
    this.branchName,
    this.designation,
    this.emailId,
    this.locCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        no: json["no"],
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        branchName: json["branchName"],
        designation: json["designation"],
        emailId: json["emailId"],
        locCode: json["locCode"],
      );

  Map<String, dynamic> toJson() => {
        "no": no,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "branchName": branchName,
        "designation": designation,
        "emailId": emailId,
        "locCode": locCode,
      };
}
