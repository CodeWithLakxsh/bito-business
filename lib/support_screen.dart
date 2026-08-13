import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'support_chat_screen.dart';
import 'telegram_service.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;

      case 'pending':
        return Colors.blue;

      case 'closed':
        return Colors.green;

      case 'representative_requested':
        return Colors.redAccent;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1020),

      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            "Support Tickets",

            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: StreamBuilder<
                QuerySnapshot>(
              stream:
                  FirebaseFirestore
                      .instance
                      .collection(
                          'support_tickets')
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

                if (!snapshot.hasData ||
                    snapshot.data!.docs
                        .isEmpty) {
                  return const Center(
                    child: Text(
                      "No Support Tickets",

                      style: TextStyle(
                        color:
                            Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final tickets =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount:
                      tickets.length,

                  itemBuilder:
                      (context, index) {

                    final ticket =
                        tickets[index];

                    final status =
                        ticket['status'] ??
                            'open';

                    return GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                SupportChatScreen(
                              ticketId:
                                  ticket.id,

                              userName:
                                  ticket[
                                          'userName'] ??
                                      '',
                            ),
                          ),
                        );
                      },

                      child: Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 18,
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
                            24,
                          ),

                          border:
                              Border.all(
                            color: Colors
                                .white
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
                                    ticket['title'] ??
                                        '',

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .white,

                                      fontSize:
                                          22,

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
                                    horizontal:
                                        12,

                                    vertical:
                                        6,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        _statusColor(
                                      status,
                                    ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                  ),

                                  child: Text(
                                    status,

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .white,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height:
                                    16),

                            Text(
                              ticket['lastMessage'] ??
                                  ticket[
                                      'message'] ??
                                  '',

                              maxLines: 2,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .white70,

                                fontSize:
                                    16,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    18),

                            Text(
                              "User: ${ticket['userName'] ?? ''}",

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .white54,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    6),

                            Text(
                              "Email: ${ticket['email'] ?? ''}",

                              style:
                                  const TextStyle(
                                color:
                                    Colors
                                        .white54,
                              ),
                            ),

                            if (ticket[
                                    'representativeRequested'] ==
                                true) ...[

                              const SizedBox(
                                  height:
                                      14),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .all(
                                  12,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .red
                                      .withOpacity(
                                    0.12,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    16,
                                  ),
                                ),

                                child: const Row(
                                  children: [

                                    Icon(
                                      Icons
                                          .support_agent_rounded,

                                      color:
                                          Colors
                                              .redAccent,
                                    ),

                                    SizedBox(
                                        width:
                                            10),

                                    Expanded(
                                      child:
                                          Text(
                                        "User requested a representative",

                                        style:
                                            TextStyle(
                                          color:
                                              Colors
                                                  .white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(
                                height:
                                    24),

                            Row(
                              children: [

                                ElevatedButton(
                                  onPressed: () async {

  await FirebaseFirestore
      .instance
      .collection(
          'support_tickets')
      .doc(
          ticket.id)
      .update({
    "status":
        "closed",

    "updatedAt":
        FieldValue
            .serverTimestamp(),
  });

  await TelegramService.sendMessage(
    '''
✅ SUPPORT TICKET CLOSED

👤 User:
${ticket['userName'] ?? 'Unknown'}

📧 Email:
${ticket['email'] ?? 'No Email'}

🎫 Ticket ID:
${ticket.id}

''',
  );
},

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        Colors
                                            .green,
                                  ),

                                  child:
                                      const Text(
                                    "Close",
                                  ),
                                ),

                                const SizedBox(
                                    width:
                                        14),

                                ElevatedButton(
                                  onPressed:
    () async {

  await FirebaseFirestore
      .instance
      .collection(
          'support_tickets')
      .doc(
          ticket.id)
      .update({
    "status":
        "pending",

    "representativeRequested":
        false,

    "updatedAt":
        FieldValue
            .serverTimestamp(),
  });

  await TelegramService.sendMessage(
    '''
🟢 REPRESENTATIVE ACCEPTED

👤 User:
${ticket['userName'] ?? 'Unknown'}

📧 Email:
${ticket['email'] ?? 'No Email'}

🎫 Ticket ID:
${ticket.id}

Admin joined support chat.

''',
  );
},

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        Colors
                                            .blue,
                                  ),

                                  child:
                                      const Text(
                                    "Accept",
                                  ),
                                ),

                                const SizedBox(
                                    width:
                                        14),

                                ElevatedButton(
                                  onPressed:
                                      () async {

                                    await FirebaseFirestore
                                        .instance
                                        .collection(
                                            'support_tickets')
                                        .doc(
                                            ticket.id)
                                        .delete();
                                  },

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),

                                  child:
                                      const Text(
                                    "Delete",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}