// ignore_for_file: must_be_immutable, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cehpoint_marketplace/common/colors.dart';

class PropertyMessageScreen extends StatefulWidget {
  String receiverName;
  String receiverEmail;
  String myName;
  String myEmail;
  String userType;

  PropertyMessageScreen({
    super.key,
    required this.myEmail,
    required this.userType,
    required this.myName,
    required this.receiverEmail,
    required this.receiverName,
  });

  @override
  State<PropertyMessageScreen> createState() => _PropertyMessageScreenState();
}

class _PropertyMessageScreenState extends State<PropertyMessageScreen> {
  final TextEditingController _textController = TextEditingController();
  String roomID = "";

  @override
  void initState() {
    super.initState();
    findChatRoomId(widget.receiverEmail, widget.myEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.green700,
        title: Text(
          widget.receiverName,
          style: const TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/chat_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.25),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            if (roomID == "")
              const Expanded(
                  child: Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()))),
            if (roomID != "")
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomID)
                      .collection('messages')
                      .orderBy('Date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        bool isBuyer = data['Sender'] == widget.myEmail;

                        BubbleStyle style = (isBuyer)
                            ? const BubbleStyle(
                                nip: BubbleNip.rightTop,
                                color: ColorConstants.blue50,
                                elevation: 1.0, // Adjust elevation as needed
                                margin: BubbleEdges.only(top: 8.0, left: 50.0),
                                alignment: Alignment.topRight,
                              )
                            : const BubbleStyle(
                                nip: BubbleNip.leftTop,
                                color: ColorConstants.blue50,
                                elevation: 1.0, // Adjust elevation as needed
                                margin: BubbleEdges.only(top: 8.0, right: 50.0),
                                alignment: Alignment.topLeft,
                              );

                        return Column(
                          crossAxisAlignment: (isBuyer)
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Bubble(
                              style: style,
                              child: Text(
                                data['Text'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                timeAgo(data['Date']
                                    .toDate()), // Assuming you have a method to format the date
                                style: const TextStyle(
                                  fontSize: 12.0, // Adjust font size as needed
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(
                          color: Colors.black), // Set text color
                      cursorColor: Colors.black, // Set cursor color
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                        hintText: 'Write message here',
                        hintStyle: const TextStyle(fontSize: 14),
                        // Set hint text color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.transparent), // Set border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors
                                  .transparent), // Set enabled border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.blue700,
                    ),
                    width: 60,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_textController.text == "") {
                          Fluttertoast.showToast(
                            msg: 'Write some message to send',
                            backgroundColor: Colors.grey,
                          );
                        } else {
                          if (roomID == "blank") {
                            DocumentReference<Map<String, dynamic>>
                                newChatRoomRef = FirebaseFirestore.instance
                                    .collection('chatrooms')
                                    .doc();
                            await newChatRoomRef.set({
                              'Last Message': "",
                              'Participants': [
                                widget.myEmail,
                                widget.receiverEmail
                              ],
                            }).then((value) {
                              setState(() {
                                roomID = newChatRoomRef.id;
                              });
                            });
                            String x = _textController.text;
                            _textController.text = "";
                            await FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(roomID)
                                .collection('messages')
                                .doc('${DateTime.now().millisecondsSinceEpoch}')
                                .set({
                              'Date': DateTime.now(),
                              'Seen': "False",
                              'Sender': widget.myEmail,
                              'Text': x,
                              'Type': "message",
                            });
                            await FirebaseFirestore.instance
                                .collection('Buyers')
                                .doc(widget.myEmail)
                                .collection('Chat History')
                                .doc(widget.receiverEmail)
                                .set({
                              'Last Message Date': DateTime.now(),
                              'Last Message': x,
                              'Sender': widget.receiverName,
                              'User Type': widget.userType
                            });
                            await FirebaseFirestore.instance
                                .collection((widget.userType == "Seller")
                                    ? "users"
                                    : "Agents")
                                .doc(widget.receiverEmail)
                                .collection('Chat History')
                                .doc(widget.myEmail)
                                .set({
                              'Last Message Date': DateTime.now(),
                              'Last Message': x,
                              'Sender': widget.myName,
                              'User Type': 'Buyers'
                            });
                          } else if (roomID != "") {
                            String x = _textController.text;
                            _textController.text = "";
                            await FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(roomID)
                                .collection('messages')
                                .doc('${DateTime.now().millisecondsSinceEpoch}')
                                .set({
                              'Date': DateTime.now(),
                              'Seen': "False",
                              'Sender': widget.myEmail,
                              'Text': x,
                              'Type': "message",
                            });
                            await FirebaseFirestore.instance
                                .collection('Buyers')
                                .doc(widget.myEmail)
                                .collection('Chat History')
                                .doc(widget.receiverEmail)
                                .update({
                              'Last Message Date': DateTime.now(),
                              'Last Message': x,
                            });
                            await FirebaseFirestore.instance
                                .collection((widget.userType == "Seller")
                                    ? "users"
                                    : "Agents")
                                .doc(widget.receiverEmail)
                                .collection('Chat History')
                                .doc(widget.myEmail)
                                .update({
                              'Last Message Date': DateTime.now(),
                              'Last Message': x,
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void findChatRoomId(String participantId1, String participantId2) async {
    try {
      String localRoomID = "";
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('chatrooms').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> room
          in querySnapshot.docs) {
        List<dynamic>? participants = room.data()['Participants'];

        if (participants != null &&
            participants.contains(participantId1) &&
            participants.contains(participantId2)) {
          setState(() {
            localRoomID = room.id;
          });
        }
      }
      if (localRoomID == "") {
        setState(() {
          roomID = "blank";
        });
      } else {
        setState(() {
          roomID = localRoomID;
        });
      }
    } catch (e) {}
  }

  String timeAgo(DateTime date) {
    // Implement this method to format date as time ago string
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
