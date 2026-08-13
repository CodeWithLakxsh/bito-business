import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'telegram_service.dart';
import 'ai_chat_detail_screen.dart';

class AiChatMonitorScreen extends StatelessWidget {
  const AiChatMonitorScreen({super.key});

  Color _statusColor(bool requested) {
    if (requested) {
      return Colors.redAccent;
    }

    return Colors.green;
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
            "AI Chat Monitoring",

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
                          'ai_chats')
                      .orderBy(
                        'updatedAt',
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
                      "No AI Chats Found",

                      style: TextStyle(
                        color:
                            Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final chats =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount:
                      chats.length,

                  itemBuilder:
                      (context, index) {

                    final chat =
                        chats[index];

                    final representativeRequested =
                        chat['representativeRequested'] ??
                            false;

                    return GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                AiChatDetailScreen(
                              chatId:
                                  chat.id,

                              userName:
                                  chat['userName'] ??
                                      'Unknown User',
                            ),
                          ),
                        );
                      },

                      child: Container(
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
                                    chat['userName'] ??
                                        'Unknown User',

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,

                                      fontSize:
                                          22,

                                      fontWeight:
                                          FontWeight.bold,
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
                                        _statusColor(
                                      representativeRequested,
                                    ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                  ),

                                  child: Text(
                                    representativeRequested
                                        ? 'REPRESENTATIVE REQUESTED'
                                        : 'AI ACTIVE',

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 18),

                            Text(
                              "Last User Message",

                              style:
                                  TextStyle(
                                color:
                                    Colors.orange
                                        .shade300,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              chat['lastUserMessage'] ??
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
                              "Last AI Reply",

                              style:
                                  TextStyle(
                                color:
                                    Colors.green
                                        .shade300,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              chat['lastAiMessage'] ??
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
                              "User Email: ${chat['email'] ?? ''}",

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white54,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              "User ID: ${chat['userId'] ?? ''}",

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white38,
                              ),
                            ),

                            const SizedBox(
                                height: 24),

                            if (representativeRequested)
                              Row(
                                children: [

                                  ElevatedButton(
                                    onPressed:
                                        () async {

                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                              'ai_chats')
                                          .doc(
                                              chat.id)
                                          .update({
                                        "representativeRequested":
                                            false,

                                        "status":
                                            "human_joined",

                                        "updatedAt":
                                            FieldValue
                                                .serverTimestamp(),
                                      });

                                      await TelegramService.sendMessage(
                                        '''
🟢 AI CHAT REPRESENTATIVE ACCEPTED

👤 User:
${chat['userName'] ?? 'Unknown'}

📧 Email:
${chat['email'] ?? 'No Email'}

🆔 Chat ID:
${chat.id}

Admin joined AI support.

''',
                                      );

                                      if (context.mounted) {

                                        Navigator.push(
                                          context,

                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AiChatDetailScreen(
                                              chatId:
                                                  chat.id,

                                              userName:
                                                  chat['userName'] ??
                                                      'Unknown User',
                                            ),
                                          ),
                                        );
                                      }
                                    },

                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          Colors.green,
                                    ),

                                    child:
                                        const Text(
                                      "Accept Representative",
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