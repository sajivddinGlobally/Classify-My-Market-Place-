// To parse this JSON data, do
//
//     final googleLoginBodyResModel = googleLoginBodyResModelFromJson(jsonString);

import 'dart:convert';

GoogleLoginBodyResModel googleLoginBodyResModelFromJson(String str) => GoogleLoginBodyResModel.fromJson(json.decode(str));

String googleLoginBodyResModelToJson(GoogleLoginBodyResModel data) => json.encode(data.toJson());

class GoogleLoginBodyResModel {
    String? idToken;

    GoogleLoginBodyResModel({
        this.idToken,
    });

    factory GoogleLoginBodyResModel.fromJson(Map<String, dynamic> json) => GoogleLoginBodyResModel(
        idToken: json["id_token"],
    );

    Map<String, dynamic> toJson() => {
        "id_token": idToken,
    };
}







// To parse this JSON data, do
//
//     final facebookLoginBodyModel = facebookLoginBodyModelFromJson(jsonString);



FacebookLoginBodyModel facebookLoginBodyModelFromJson(String str) => FacebookLoginBodyModel.fromJson(json.decode(str));

String facebookLoginBodyModelToJson(FacebookLoginBodyModel data) => json.encode(data.toJson());

class FacebookLoginBodyModel {
    String? accessToken;

    FacebookLoginBodyModel({
        this.accessToken,
    });

    factory FacebookLoginBodyModel.fromJson(Map<String, dynamic> json) => FacebookLoginBodyModel(
        accessToken: json["access_token"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
    };
}
