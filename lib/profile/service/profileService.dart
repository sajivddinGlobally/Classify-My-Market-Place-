import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' hide Header;
import 'package:shopping_app_olx/profile/Model/profileModel.dart';

part 'profileService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class ProfileService {
  factory ProfileService(Dio dio, {String baseUrl}) = _ProfileService;

  @GET('/api/user/profile?user_id={id}')
  Future<ProfileModel> profile(@Path("id") String id);
} 
