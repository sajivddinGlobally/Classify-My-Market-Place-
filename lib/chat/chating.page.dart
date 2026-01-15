/*
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_olx/chat/controller/inboxProvider.provider.dart';
import 'package:shopping_app_olx/chat/model/mesagesList.response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatingPage extends ConsumerStatefulWidget {
  final String userid;
  final String name;
  const ChatingPage({super.key, required this.userid, required this.name});
  @override
  ConsumerState<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends ConsumerState<ChatingPage> {

  final controller = TextEditingController();
  late WebSocketChannel channel;
  final ScrollController _scrollController = ScrollController();
*/
/*

  @override
  void initState() {

    super.initState();
    final box = Hive.box("data");1
    final id = box.get("id");


    // Connect WebSocket
    channel = WebSocketChannel.connect(
      Uri.parse('ws://websocket.mymarketplace.co.in/chat/ws/$id'),
    );


    // Page open hone ke turant baad scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

  }
*/ /*



  @override
  void initState() {
    super.initState();
    final box = Hive.box("data");
    final id = box.get("id");

    // Connect WebSocket
    channel = WebSocketChannel.connect(
      Uri.parse('ws://websocket.mymarketplace.co.in/chat/ws/$id'),
    );

    // Invalidate messageProvider
    Future.microtask(() {
      ref.invalidate(messageProvider(widget.userid));
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }




  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final messagesList = ref.watch(messageProvider(widget.userid));
    final box = Hive.box("data");
    final id = box.get("id");

    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 245, 242, 247),
      appBar:


      AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading:
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title:
        Container(
          height: 34.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.45.r),
            color: const Color.fromARGB(25, 137, 26, 255),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                widget.name,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 137, 26, 255),
                ),
              ),
            ),
          ),
        ),
      ),


      body:



      messagesList.when(

        data: (snap) {
          // Jab bhi data load ho, scroll to bottom
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [

              Expanded(
                child: StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {


                    if (snapshot.hasData) {
                      log("Incoming: ${snapshot.data}");

                      try {

                        final data = jsonDecode(snapshot.requireData);

                        if (!snap.chat.any((m) => m.id == data['id'])) {

                          snap.chat.add(
                            Chat(
                              id: data["id"],
                              sender: int.parse(data['sender_id']),
                              message: data['message'],
                              timestamp: DateTime.now(),
                            ),
                          );

                          _scrollToBottom();

                        }

                        _scrollToBottom();

                      }

                      catch (e) {
                        log("Error parsing: $e");
                      }


                    }




                    return ListView.builder(

                      controller: _scrollController,
                      itemCount: snap.chat.length,


                      itemBuilder: (context, index) {
                        final e = snap.chat[index];

                        return ChatBubble(
                          isUserMessage: e.sender.toString() != id.toString(),
                          message: e.message,
                          dateTime: e.timestamp.toString(),

                        );



                      },
                    );


                  },

                ),

              ),

              MessageInput(
                controller: controller,
                onSend: () {
                  if (controller.text.trim().isEmpty) return;

                  channel.sink.add(
                    jsonEncode({
                      "receiver_id": widget.userid,
                      "message": controller.text,
                    }),
                  );

                  setState(() {
                    snap.chat.add(
                      Chat(
                        id: "sender",
                        sender: int.parse(id.toString()),
                        message: controller.text,
                        timestamp: DateTime.now(),
                      ),
                    );
                    controller.clear();
                  });
                  _scrollToBottom();
                },
              ),

            ],
          );

        },

        error: (err, stack) => Center(child: Text("$err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),





    );
  }
}






// class ChatBubble extends StatelessWidget {
//
//   final bool isUserMessage;
//   final String message;
//   final String dateTime;
//
//   const ChatBubble({
//     super.key,
//     required this.isUserMessage,
//     required this.message,
//     required this.dateTime,
//   });
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           decoration: BoxDecoration(
//             color:
//                 isUserMessage
//                     ? Colors.white
//                     : const Color.fromARGB(255, 137, 26, 255),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r),
//               topRight: Radius.circular(20.r),
//               bottomRight: isUserMessage ? Radius.circular(20.r) : Radius.zero,
//               bottomLeft: isUserMessage ? Radius.zero : Radius.circular(20.r),
//             ),
//           ),
//           child: Text(
//             message,
//             style: GoogleFonts.dmSans(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               color:
//                   isUserMessage
//                       ? const Color.fromARGB(255, 97, 91, 104)
//                       : Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }




class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final String message;
  final String dateTime;

  const ChatBubble({
    super.key,
    required this.isUserMessage,
    required this.message,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the dateTime string to DateTime, if needed
    DateTime? parsedDateTime;
    try {
      parsedDateTime = DateTime.parse(dateTime);
    } catch (e) {
      parsedDateTime = null; // Handle invalid dateTime gracefully
    }

    // Format the dateTime to a user-friendly format (e.g., "6:42 PM")
    final formattedTime = parsedDateTime != null
        ? DateFormat('h:mm a').format(parsedDateTime) // e.g., "6:42 PM"
        : dateTime; // Fallback to raw string if parsing fails

    return Align(
      alignment: isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isUserMessage
                ? Colors.white
                : const Color.fromARGB(255, 137, 26, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
              bottomRight: isUserMessage ? Radius.circular(20.r) : Radius.zero,
              bottomLeft: isUserMessage ? Radius.zero : Radius.circular(20.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isUserMessage
                      ? const Color.fromARGB(255, 97, 91, 104)
                      : Colors.white,
                ),
              ),
              SizedBox(height: 4.h), // Small spacing between message and time
              Text(
                formattedTime,
                style: GoogleFonts.dmSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: isUserMessage
                      ? const Color.fromARGB(255, 97, 91, 104).withOpacity(0.7)
                      : Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15.h, left: 15.w),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: GestureDetector(
                  onTap: onSend,
                  child: Icon(
                    Icons.send,
                    color: const Color.fromARGB(255, 137, 26, 255),
                    size: 25.sp,
                  ),
                ),
                hintText: "Type Message...",
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 97, 91, 104),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_olx/chat/controller/inboxProvider.provider.dart';
import 'package:shopping_app_olx/chat/model/mesagesList.response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatingPage extends ConsumerStatefulWidget {
  final String conversationId;
  final String userid;
  final String name;
  const ChatingPage({super.key,
    required this.conversationId,
    required this.userid,
    required this.name,});
  @override
  ConsumerState<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends ConsumerState<ChatingPage> with RouteAware {
  final controller = TextEditingController();
  late WebSocketChannel channel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final box = Hive.box("data");
    final id = box.get("id");
    http://192.168.1.39:8080/docs
    // Connect WebSocket
    // channel = WebSocketChannel.connect(
    //   Uri.parse('ws://websocket.mymarketplace.co.in/chat/ws/$id'),
    // );

     channel = WebSocketChannel.connect(
      Uri.parse('ws://websocket.mymarketplace.co.in/chat/ws/$id'),
    );
    // https://websocket.mymarketplace.co.in/


    // Invalidate messageProvider
    Future.microtask(() {
      ref.invalidate(messageProvider(widget.userid));
      ref.invalidate(markSeen(widget.conversationId));


    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      // routeObserver.subscribe(this, modalRoute);
    }
  }
  @override
  void didPopNext() {
    Future.microtask(() {
      ref.invalidate(messageProvider(widget.userid));
      ref.invalidate(markSeen(widget.conversationId));
      _reconnectWebSocket();
    });
  }
  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
    channel.sink.close();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void _reconnectWebSocket() {
    final box = Hive.box("data");
    final id = box.get("id");
    channel.sink.close();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://websocket.mymarketplace.co.in/chat/ws/$id'),
    );
    setState(() {});
  }
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  // Helper function to format date headers
  String _formatDateHeader(DateTime dateTime, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(messageDate).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference <= 7) {
      return "$difference days ago";
    } else {
      return DateFormat('MMM d').format(dateTime); // e.g., "Sep 8"
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.watch(markSeen(widget.conversationId));
    final messagesList = ref.watch(messageProvider(widget.userid));
     ref.watch(markSeen(widget.conversationId));
    final box = Hive.box("data");
    final id = box.get("id");
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 247),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Container(
          height: 34.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.45.r),
            color: const Color.fromARGB(25, 137, 26, 255),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                widget.name,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 137, 26, 255),
                ),
              ),
            ),
          ),
        ),
      ),

      body: messagesList.when(
        data: (snap) {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [

              Expanded(
                child: RefreshIndicator(

                  onRefresh: () async {
                    // await Future.wait([
                    ref.refresh(messageProvider(widget.userid));
                    ref.refresh(markSeen(widget.conversationId));
                    Future(() => _reconnectWebSocket());
                    // ]);
                  },

                  child: StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("WebSocket Error: ${snapshot.error}"),
                              ElevatedButton(
                                onPressed: _reconnectWebSocket,
                                child: Text("Reconnect"),
                              ),
                            ],
                          ),
                        );
                      }
                      ////////////////////////////////////////////////     ye bhi sahi code hai ////////////////////////////////

                      // if (snapshot.hasData) {
                      //   try {
                      //     final data = jsonDecode(snapshot.requireData);
                      //     final messageId = data["id"];
                      //     final existingIndex = snap.chat.indexWhere(
                      //       (m) =>
                      //           m.id == "sender" &&
                      //           m.message == data['message'],
                      //     );
                      //     if (existingIndex != -1) {
                      //       setState(() {
                      //         snap.chat[existingIndex] = Chat(
                      //           id: messageId,
                      //           sender: int.parse(data['sender_id']),
                      //           message: data['message'],
                      //           timestamp:
                      //               data['timestamp'] != null
                      //                   ? DateTime.parse(data['timestamp'])
                      //                   : DateTime.now(),
                      //         );
                      //       });
                      //     } else if (!snap.chat.any((m) => m.id == messageId)) {
                      //       setState(() {
                      //         snap.chat.add(
                      //           Chat(
                      //             id: messageId,
                      //             sender: int.parse(data['sender_id']),
                      //             message: data['message'],
                      //             timestamp:
                      //                 data['timestamp'] != null
                      //                     ? DateTime.parse(data['timestamp'])
                      //                     : DateTime.now(),
                      //           ),
                      //         );
                      //       });
                      //     }
                      //     _scrollToBottom();
                      //   } catch (e) {
                      //     log("Error parsing: $e");
                      //   }
                      // }

                      if (snapshot.hasData) {
                        try {

                          final data = jsonDecode(snapshot.requireData);
                          final messageId = data["id"];

                          final existingIndex = snap.chat.indexWhere(
                            (m) =>
                                m.id == "sender" &&
                                m.message == data['message'],
                          );

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (existingIndex != -1) {
                              setState(() {
                                snap.chat[existingIndex] = Chat(
                                  id: messageId,
                                  sender: int.parse(data['sender_id'].toString()),
                                  message: data['message'],
                                  timestamp:
                                      data['timestamp'] != null
                                          ? DateTime.parse(data['timestamp'])
                                          : DateTime.now(),
                                );
                              });
                            }
                            else if (!snap.chat.any(
                              (m) => m.id == messageId,
                            )) {
                              setState(() {
                                snap.chat.add(
                                  Chat(
                                    id: messageId,
                                    sender: int.parse(data['sender_id'].toString()),
                                    message: data['message'],
                                    timestamp:
                                        data['timestamp'] != null
                                            ? DateTime.parse(data['timestamp'])
                                            : DateTime.now(),
                                  ),
                                );
                              });
                            }
                            _scrollToBottom();
                          });

                        } catch (e) {

                          log("Error parsing: $e");

                        }

                      }

                      // Sort messages by timestamp to ensure correct order
                      final sortedChats =
                          snap.chat..sort(
                            (a, b) => a.timestamp.compareTo(b.timestamp),
                          );

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: sortedChats.length,
                        itemBuilder: (context, index) {
                          final e = sortedChats[index];
                          final currentDate = DateTime(
                            e.timestamp.year,
                            e.timestamp.month,
                            e.timestamp.day,
                          );
                          final showDateHeader =
                              index == 0 ||
                              currentDate !=
                                  DateTime(
                                    sortedChats[index - 1].timestamp.year,
                                    sortedChats[index - 1].timestamp.month,
                                    sortedChats[index - 1].timestamp.day,
                                  );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (showDateHeader) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Text(
                                    _formatDateHeader(e.timestamp, now),
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                        255,
                                        97,
                                        91,
                                        104,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              ChatBubble(
                                isUserMessage:
                                    e.sender.toString() != id.toString(),
                                message: e.message,
                                dateTime: e.timestamp.toString(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              MessageInput(
                controller: controller,
                onSend: () {
                  if (controller.text.trim().isEmpty) return;
                  final message = controller.text;
                  channel.sink.add(
                    jsonEncode({
                      "receiver_id": widget.userid,
                      "message": message,
                    }),
                  );
                  setState(() {
                    snap.chat.add(
                      Chat(
                        id: "sender",
                        sender: int.parse(id.toString()),
                        message: message,
                        timestamp: DateTime.now(),
                      ),
                    );
                    controller.clear();
                  });
                  _scrollToBottom();
                },
              ),
            ],
          );
        },
        error:
            (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: $err"),
                  ElevatedButton(
                    onPressed:
                        () => ref.invalidate(messageProvider(widget.userid)),
                    child: Text("Retry"),
                  ),
                ],
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}


class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final String message;
  final String dateTime;

  const ChatBubble({
    super.key,
    required this.isUserMessage,
    required this.message,
    required this.dateTime,
  });

  // Format the dateTime to show relative time
  String _formatRelativeTime(String dateTime, DateTime now) {
    DateTime? parsedDateTime;
    try {
      parsedDateTime = DateTime.parse(dateTime);
    } catch (e) {
      return dateTime; // Fallback to raw string if parsing fails
    }

    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      parsedDateTime.year,
      parsedDateTime.month,
      parsedDateTime.day,
    );
    final difference = today.difference(messageDate).inDays;

    final timeFormat = DateFormat(
      'h:mm a',
    ).format(parsedDateTime); // e.g., "6:42 PM"

    if (difference == 0) {
      return "Today, $timeFormat";
    } else if (difference == 1) {
      return "Yesterday, $timeFormat";
    } else if (difference <= 7) {
      return "$difference days ago, $timeFormat";
    } else {
      return "${DateFormat('MMM d').format(parsedDateTime)}, $timeFormat";
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedTime = _formatRelativeTime(dateTime, now);

    return Align(
      alignment: isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color:
                isUserMessage
                    ? Colors.white
                    : const Color.fromARGB(255, 137, 26, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
              bottomRight: isUserMessage ? Radius.circular(20.r) : Radius.zero,
              bottomLeft: isUserMessage ? Radius.zero : Radius.circular(20.r),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isUserMessage
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      isUserMessage
                          ? const Color.fromARGB(255, 97, 91, 104)
                          : Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                formattedTime,
                style: GoogleFonts.dmSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color:
                      isUserMessage
                          ? const Color.fromARGB(
                            255,
                            97,
                            91,
                            104,
                          ).withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      // color: Colors.white,
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15.h, left: 15.w),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide(color: Colors.black, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.r),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 137, 26, 255),
                    width: 1.w,
                  ),
                ),
                // suffixIcon: GestureDetector(
                //   onTap: onSend,
                //   child: Icon(
                //     Icons.send,
                //     color: const Color.fromARGB(255, 137, 26, 255),
                //     size: 25.sp,
                //   ),
                // ),
                hintText: "Type Message...",
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 97, 91, 104),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: onSend,
            child: Container(
              width: 55.w,
              height: 55.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 137, 26, 255),
              ),
              child: Center(
                child: Icon(Icons.send, color: Colors.white, size: 25.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
