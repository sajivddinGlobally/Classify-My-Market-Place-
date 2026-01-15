/*
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/chat/chating.page.dart';
import 'package:shopping_app_olx/chat/controller/inboxProvider.provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});
  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(inboxProvider);
    });
    // Listen to search text changes
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final inboxListASync = ref.watch(inboxProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 247),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(inboxProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  "Message",
                  style: GoogleFonts.dmSans(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 36, 33, 38),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 13.h,
                      horizontal: 13.w,
                    ),
                    prefixIcon: Icon(Icons.search, size: 20.sp),
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
                    hintText: "Search chats...",
                    hintStyle: GoogleFonts.dmSans(fontSize: 19.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            /// Inbox List
            inboxListASync.when(
              data: (snap) {
                // ✅ Apply search filter here
                final filteredInbox =
                    snap.inbox!.where((chat) {
                      final name = chat.otherUser!.name!.toLowerCase();
                      return name.contains(searchQuery);
                    }).toList();

                if (filteredInbox.isEmpty) {
                  return Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? "No recent messages"
                          : "No chats found for '$searchQuery'",
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 36, 33, 38),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,

                      itemCount: filteredInbox.length,
                      itemBuilder: (context, index) {
                        final chat = filteredInbox[index];



                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: GestureDetector(
                            onTap: () {

                              final converId = chat.conversationId;
                              final userid = snap.egedUser!.id;

                              ref.watch(markSeen(converId));

                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder:
                                      (context) => ChatingPage(
                                        userid: chat.otherUser!.id.toString(),
                                        name: chat.otherUser!.name!,
                                      ),
                                ),
                              );
                            },
                            child:
                            NameBody(
                              isReaded: chat.otherUser?.isReaded ?? false,
                              image: chat.otherUser?.profilePic ?? '', // or a default placeholder
                              name: chat.otherUser?.name ?? 'Unknown',
                              txt: () {
                                if (chat.otherUser?.senderYou == true) {
                                  return chat.lastMessage ?? '';
                                } else if (chat.otherUser?.isReaded == false) {
                                  return "New message";
                                } else {
                                  return chat.lastMessage ?? '';
                                }
                              }(), 
                              time: () {
                                if (chat.timestamp == null) return '';
                                final DateTime date = chat.timestamp!;
                                final String hour = date.hour.toString();
                                final String minute = date.minute.toString().padLeft(2, '0');
                                return "$hour:$minute";
                              }(),
                              isDivider: true,
                            ),


                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              error: (err, stack) {
                log(stack.toString());
                log(err.toString());
                return Center(
                  child: Text("Pull to refresh\n${err.toString()}"),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

class NameBody extends StatelessWidget {
  final String image;
  final String name;
  final String txt;
  final String time;
  final bool isDivider;
  final bool isReaded;

  const NameBody({
    super.key,
    required this.image,
    required this.name,
    required this.txt,
    required this.time,
    required this.isDivider,
    required this.isReaded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            /// Profile Image
            ///
            ClipOval(
              child: Image.network(
                "//classfiy.onrender.com" + image,
                fit: BoxFit.cover,
                width: 44.w,
                height: 44.h,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported),
              ),
            ),

            SizedBox(width: 10.w),

            /// Name + Message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 36, 33, 38),
                  ),
                ),
                Text(
                  txt,
                  style: GoogleFonts.dmSans(
                    fontSize: 12.sp,
                    fontWeight: isReaded ? FontWeight.w500 : FontWeight.bold,
                    color: isReaded==true ? Colors.black : Colors.red
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            const Spacer(),

            /// Time
            Text(
              time,
              style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 97, 91, 104),
              ),
            ),

          ],
        ),

        SizedBox(height: 10.h),
        isDivider ? const Divider() : const SizedBox(),
      ],
    );
  }
}
*/

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/chat/chating.page.dart';
import 'package:shopping_app_olx/chat/controller/inboxProvider.provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});
  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> with WidgetsBindingObserver {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshInbox();

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshInbox();
    }
  }

  void _refreshInbox() {
    Future.microtask(() {
      ref.invalidate(inboxProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inboxListASync = ref.watch(inboxProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 247),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(inboxProvider.future);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  "Message",
                  style: GoogleFonts.dmSans(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 36, 33, 38),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 13.h,
                    horizontal: 13.w,
                  ),
                  prefixIcon: Icon(Icons.search, size: 20.sp),
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
                  hintText: "Search chats...",
                  hintStyle: GoogleFonts.dmSans(fontSize: 19.sp),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            /// Inbox List
            inboxListASync.when(
              data: (snap) {
                final filteredInbox = snap.inbox!
                    .where((chat) =>
                    chat.otherUser!.name!.toLowerCase().contains(searchQuery))
                    .toList();

                if (filteredInbox.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? "No recent messages"
                            : "No chats found for '$searchQuery'",
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 36, 33, 38),
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredInbox.length,
                      itemBuilder: (context, index) {
                        final chat = filteredInbox[index];

                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: GestureDetector(
                            onTap: () async {
                              // Mark as seen (assuming markSeenProvider is a notifier)
                              // ref.read(markSeenProvider(chat.conversationId));

                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ChatingPage(
                                    conversationId: chat.conversationId!,
                                    userid: chat.otherUser!.id.toString(),
                                    name: chat.otherUser!.name!,
                                  ),
                                ),
                              );

                              // Back आने पर list refresh
                              _refreshInbox();
                            },
                            child: NameBody(
                              isReaded: chat.otherUser!.isReaded ?? false, // model के according adjust कर लेना
                              image: chat.otherUser?.profilePic ?? '',
                              name: chat.otherUser?.name ?? 'Unknown',
                              txt: chat.lastMessage ?? '',
                              time: _formatTime(chat.timestamp),
                              isDivider: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              error: (err, stack) {
                log(err.toString());
                return Expanded(
                  child: Center(
                    child: Text("Error: ${err.toString()}\nPull to refresh"),
                  ),
                );
              },
              loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return '';
    return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}

class NameBody extends StatelessWidget {
  final String image;
  final String name;
  final String txt;
  final String time;
  final bool isDivider;
  final bool isReaded;

  const NameBody({
    super.key,
    required this.image,
    required this.name,
    required this.txt,
    required this.time,
    required this.isDivider,
    required this.isReaded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.network(
                "https://classfiy.onrender.com$image",
                width: 44.w,
                height: 44.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.person, size: 44.r),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 36, 33, 38),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    txt,
                    style: GoogleFonts.dmSans(
                      fontSize: 12.sp,
                      fontWeight: isReaded ? FontWeight.w500 : FontWeight.bold,
                      color: isReaded ? Colors.black : Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 97, 91, 104),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (isDivider) const Divider(),
      ],
    );
  }
}