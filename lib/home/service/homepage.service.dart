import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/home/model/allCategoryModel.dart';
import 'package:shopping_app_olx/home/model/homepageModel.dart';
part 'homepage.service.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class HomePageService {
  factory HomePageService(Dio dio, {String baseUrl}) = _HomePageService;

  @GET('/api/home?latitude={latitude}&longitude={longitude}&user_id={user_id}')
  Future<HomepageModel> home(
    @Path('latitude') String latitude,
    @Path('longitude') String longitude,
    @Path('user_id') String user_id,
  );

  @GET('/api/categories')
  Future<AllCategoryModel> allCategory();
}
 /// parser: parser.flutterComput  ise response fast call hogi
 /// baseUrl : "//classfiy.onrender.com", parser:parser.flutterComput 