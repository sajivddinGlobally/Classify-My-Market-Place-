// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class Uploadproductimagecontroller {
//   static Future<Map<String, dynamic>> uploadProductImages({
//     required String productId,
//     required List<File> images,
//   }) async {
//     final Uri url = Uri.parse(
//       '//classfiy.onrender.com/api/product/images',
//     );

//     var request = http.MultipartRequest("POST", url);

//     request.headers.addAll({"Accept": "application/json"});

//     if (images.isNotEmpty) {
//       request.files.add(
//         await http.MultipartFile.fromPath("image", images.first.path),
//       );

//       for (int i = 1; i < images.length; i++) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'images[]', // ✅ Match the expected field name from API
//             images[i].path,
//           ),
//         );
//       }
//     }

//     request.fields["product_id"] = productId;

//     final response = await request.send();
//     final responseBody = await response.stream.bytesToString();

//     log(responseBody);

//     final data = jsonDecode(responseBody);
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       return data;
//     } else {
//       throw Exception("Failed to upload: ${response.reasonPhrase}, $data");
//     }
//   }
// }
