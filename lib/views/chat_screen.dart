import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letschat/components/components.dart';
import 'package:letschat/models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.currentEmail});
  final String currentEmail;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  final listviewController = ScrollController();

  String msg = "";

  TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              signOut(context);
              setState(() {});
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const AppBarTitle(),
      ),
      body: ChatThemeContainer(
        child: StreamBuilder<QuerySnapshot>(
          stream: messages.orderBy("createdAt", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                ),
              );
            } else if (snapshot.hasData) {
              List<Message> messagesList = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          reverse: true,
                          controller: listviewController,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => FutureBuilder(
                              future: getCurrentUsername(
                                  email: messagesList[index].id),
                              builder: (context, snapshot) {
                                final username =
                                    snapshot.data ?? 'Unknown User';

                                return MyChatContainer(
                                  username: username,
                                  isSender: messagesList[index].id ==
                                      widget.currentEmail,
                                  message: messagesList[index],
                                );
                              }),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: messagesList.length),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: msgController,
                                onChanged: (value) {
                                  msg = value;
                                },
                                decoration: const InputDecoration(
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 33, 139, 47),
                                            width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 33, 139, 47)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)))),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: FloatingActionButton(
                                  elevation: 5,
                                  backgroundColor:
                                      const Color.fromARGB(255, 9, 123, 61),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    if (msg.isNotEmpty) {
                                      messages.add({
                                        "message": msg,
                                        "createdAt": DateTime.now(),
                                        "time": DateFormat('h:mm a')
                                            .format(DateTime.now()),
                                        "id": widget.currentEmail,
                                      });
                                    }
                                    msg = "";
                                    msgController.clear();
                                    listviewController.animateTo(
                                      0,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                  }),
                            )
                          ],
                        ))
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
