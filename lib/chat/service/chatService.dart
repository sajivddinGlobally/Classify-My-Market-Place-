import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/chat/model/inboxModel.dart';
import 'package:shopping_app_olx/chat/model/mesagesList.response.dart';

part 'chatService.g.dart';

@RestApi(baseUrl: 'https://websocket.mymarketplace.co.in')

abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl}) = _ChatService;



  @GET("/chats/inbox/{id}")
  Future<InboxListResponse> getInboxs(@Path('id') String id);



  @GET('/chats/history/{userid1}/{userid2}')
  Future<MessageListResponse> getMessage(
    @Path('userid1') String userid1,
    @Path('userid2') String userid2,
  );



  @POST('/chats/mark_seen/{conversation_id }/{user_id }')
  Future<MessageListResponse> markSeen(
      @Path('conversation_id ') String conversation_id,
      @Path('user_id ') String user_id,
      );



}
