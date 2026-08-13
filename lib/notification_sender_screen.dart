import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationSenderScreen extends StatefulWidget {
  const NotificationSenderScreen({super.key});

  @override
  State<NotificationSenderScreen> createState() =>
      _NotificationSenderScreenState();
}

class _NotificationSenderScreenState
    extends State<NotificationSenderScreen> {

  final titleController =
      TextEditingController();

  final bodyController =
      TextEditingController();

  bool isSending = false;

  Future<void> sendNotification() async {

    if (titleController.text.trim().isEmpty ||
        bodyController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter title and message",
          ),
        ),
      );

      return;
    }

    setState(() {
      isSending = true;
    });

    try {

      // =======================================================
      // 🔥 SAVE IN FIRESTORE
      // =======================================================

      await FirebaseFirestore.instance
          .collection('admin_notifications')
          .add({

        "title":
            titleController.text.trim(),

        "body":
            bodyController.text.trim(),

        "createdAt":
            FieldValue.serverTimestamp(),
      });

      // =======================================================
      // 🔥 SEND PUSH NOTIFICATION
      // =======================================================

      final response =
          await http.post(

        Uri.parse(
          'https://sendnotificationtoallusers-73wvldn2ia-uc.a.run.app',
        ),

        headers: {

          'Content-Type':
              'application/json',
        },

        body: jsonEncode({

          "title":
              titleController.text.trim(),

          "body":
              bodyController.text.trim(),
        }),
      );

      debugPrint(
        "🔥 NOTIFICATION RESPONSE: ${response.body}",
      );

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Notification Sent Successfully",
          ),
        ),
      );

      titleController.clear();
      bodyController.clear();

    } catch (e) {

      debugPrint(
        "❌ NOTIFICATION ERROR: $e",
      );

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0B1020),

        elevation: 0,

        title: const Text(
          "Send Notifications",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Notification Title",

              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  titleController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(
                hintText:
                    "Big Offer Today",

                hintStyle:
                    const TextStyle(
                  color:
                      Colors.white54,
                ),

                filled: true,

                fillColor:
                    Colors.white
                        .withOpacity(
                  0.05,
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    18,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Notification Message",

              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  bodyController,

              maxLines: 6,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(
                hintText:
                    "Flat 50% OFF on all orders today.",

                hintStyle:
                    const TextStyle(
                  color:
                      Colors.white54,
                ),

                filled: true,

                fillColor:
                    Colors.white
                        .withOpacity(
                  0.05,
                ),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    18,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 240,
              height: 55,

              child: ElevatedButton.icon(
                onPressed:
                    isSending
                        ? null
                        : sendNotification,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.cyan,
                ),

                icon: isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                      ),

                label: Text(
                  isSending
                      ? "Sending..."
                      : "Send Notification",
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Recently Sent Notifications",

              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot>(
                stream:
                    FirebaseFirestore
                        .instance
                        .collection(
                            'admin_notifications')
                        .orderBy(
                          'createdAt',
                          descending: true,
                        )
                        .snapshots(),

                builder:
                    (context, snapshot) {

                  if (snapshot
                          .connectionState ==
                      ConnectionState
                          .waiting) {

                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final docs =
                      snapshot.data?.docs ??
                          [];

                  if (docs.isEmpty) {

                    return const Center(
                      child: Text(
                        "No Notifications Sent Yet",

                        style: TextStyle(
                          color:
                              Colors.white70,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        docs.length,

                    itemBuilder:
                        (context, index) {

                      final data =
                          docs[index];

                      return Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 16,
                        ),

                        padding:
                            const EdgeInsets
                                .all(20),

                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white
                              .withOpacity(
                            0.05,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            22,
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              data['title'] ??
                                  '',

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .white,

                                fontSize:
                                    20,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 10),

                            Text(
                              data['body'] ??
                                  '',

                              style:
                                  const TextStyle(
                                color: Colors
                                    .white70,

                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}