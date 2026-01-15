import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/login/Model/otpBodyModel.dart';
import 'package:shopping_app_olx/login/Model/otpResModel.dart';
import 'package:shopping_app_olx/login/service/otpService.dart';

final otpProvider = FutureProvider.family<OtpResModel, OtpBodyModel>((
  ref,
  body,
) async {
  final otpservice = OtpService(await createDio());
  return otpservice.verifyOtp(body);
});
