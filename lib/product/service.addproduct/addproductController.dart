import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/product/model.addproduct/addProductBodyModel.dart';
import 'package:shopping_app_olx/product/model.addproduct/addproductResModel.dart';
import 'package:shopping_app_olx/product/service.addproduct/addproductService.dart';

final addProductProvider =
    FutureProvider.family<AddproductResModel, AddproductBodyModel>((
      ref,
      body,
    ) async {
      final addproductservice = AddproductService(await createDio());
      return addproductservice.addProduct(body);
    });

class AddproductRegisterController {
  static Future<AddproductResModel> Addregister({
    required String category,
    required String name,
    required String price,
    required String contact,
    required String pincode,
    required String address,
    required String description,
    required String user_id,
    required File image,
  }) async {
    final Uri url = Uri.parse('https://classify.mymarketplace.co.in/api/Add/product');
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      "Accept": "application/json", // Ensure content type is correct
      // You can add other custom headers here
    });

    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.fields.addAll({
      "category": category,
      "name": name,
      "price": price,
      "contact": contact,
      "pincode": pincode,
      "address": address,
      "description": description,
      "user_id": user_id,
    });

    final http.StreamedResponse response = await request.send();
    final responsebody = await response.stream.bytesToString();
    Map<String, dynamic> data = jsonDecode(responsebody);
    log(responsebody);
    log(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddproductResModel.fromJson(data);
    } else {
      throw Exception("Failed to upload: ${response.reasonPhrase}, $data");
    }
  }
}
