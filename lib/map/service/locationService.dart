import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/map/model/locationBodyModel.dart';
import 'package:shopping_app_olx/map/model/locationResModel.dart';

part 'locationService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class LocationService {
  factory LocationService(Dio dio, {String baseUrl}) = _LocationService;


  @POST('/api/user/location')
  Future<LocationResModel> fetchLocation(@Body() LocationBodyModel body);

}
