// ============================================================
// notifications_screen.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'send_notification_screen.dart';

class NotificationsScreen
    extends StatelessWidget {

  const NotificationsScreen({
    super.key,
  });

  Color _targetColor(
    String target,
  ) {

    switch (target) {

      case 'all_users':
        return Colors.blue;

      case 'all_vendors':
        return Colors.orange;

      case 'single_user':
        return Colors.green;

      case 'single_vendor':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF111827),

        title: const Text(
          "Notifications",
        ),

        actions: [

          Padding(
            padding:
                const EdgeInsets.only(
              right: 18,
            ),

            child: ElevatedButton.icon(
              onPressed: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const SendNotificationScreen(),
                  ),
                );
              },

              icon: const Icon(
                Icons.send_rounded,
              ),

              label: const Text(
                "Send Notification",
              ),
            ),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection(
                    'notifications')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),

        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs
                  .isEmpty) {

            return const Center(
              child: Text(
                "No Notifications Yet",

                style: TextStyle(
                  color:
                      Colors.white70,
                  fontSize: 18,
                ),
              ),
            );
          }

          final notifications =
              snapshot.data!.docs;

          return ListView.builder(
            padding:
                const EdgeInsets.all(
              24,
            ),

            itemCount:
                notifications.length,

            itemBuilder:
                (context, index) {

              final notification =
                  notifications[index];

              final target =
                  notification[
                          'targetType'] ??
                      '';

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 18,
                ),

                padding:
                    const EdgeInsets.all(
                  20,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withOpacity(
                    0.05,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    24,
                  ),

                  border: Border.all(
                    color: Colors.white
                        .withOpacity(
                      0.08,
                    ),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Text(
                            notification[
                                    'title'] ??
                                '',

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 22,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                _targetColor(
                              target,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Text(
                            target
                                .toString()
                                .replaceAll(
                                  '_',
                                  ' ',
                                )
                                .toUpperCase(),

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 18),

                    Text(
                      notification[
                              'body'] ??
                          '',

                      style:
                          const TextStyle(
                        color:
                            Colors.white70,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                        height: 18),

                    Text(
                      "Sent By: ${notification['sentBy'] ?? 'admin'}",

                      style:
                          const TextStyle(
                        color:
                            Colors.white54,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}