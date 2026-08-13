import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AiChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String userName;

  const AiChatDetailScreen({
    super.key,
    required this.chatId,
    required this.userName,
  });

  @override
  State<AiChatDetailScreen> createState() =>
      _AiChatDetailScreenState();
}

class _AiChatDetailScreenState
    extends State<AiChatDetailScreen> {

  final TextEditingController
      _messageController =
          TextEditingController();

  Future<void> _sendMessage() async {
    final text =
        _messageController.text.trim();

    if (text.isEmpty) return;

    _messageController.clear();

    await FirebaseFirestore.instance
        .collection('ai_chat_messages')
        .add({
      "chatId": widget.chatId,

      "senderType": "admin",

      "senderName": "Biteo Support",

      "message": text,

      "createdAt":
          FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('ai_chats')
        .doc(widget.chatId)
        .update({
      "lastAiMessage": text,

      "status":
          "representative_joined",

      "representativeRequested":
          false,

      "updatedAt":
          FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF111827),

        title: Text(
          widget.userName,
        ),

        actions: [

          Padding(
            padding:
                const EdgeInsets.only(
              right: 12,
            ),

            child: ElevatedButton(
              onPressed: () async {

                await FirebaseFirestore
                    .instance
                    .collection(
                        'ai_chats')
                    .doc(widget.chatId)
                    .update({
                  "status":
                      "closed",

                  "updatedAt":
                      FieldValue
                          .serverTimestamp(),
                });

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),

              child:
                  const Text(
                "Close Chat",
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<
                QuerySnapshot>(
              stream:
                  FirebaseFirestore
                      .instance
                      .collection(
                          'ai_chat_messages')
                      .where(
                        'chatId',
                        isEqualTo:
                            widget.chatId,
                      )
                      .orderBy(
                        'createdAt',
                        descending: false,
                      )
                      .snapshots(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final messages =
                    snapshot.data!.docs;

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  itemCount:
                      messages.length,

                  itemBuilder:
                      (context, index) {

                    final msg =
                        messages[index];

                    final senderType =
                        msg['senderType'];

                    final isAdmin =
                        senderType ==
                            'admin';

                    final isAi =
                        senderType ==
                            'ai';

                    return Align(
                      alignment:
                          isAdmin
                              ? Alignment
                                  .centerRight
                              : Alignment
                                  .centerLeft,

                      child: Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 12,
                        ),

                        padding:
                            const EdgeInsets
                                .all(14),

                        constraints:
                            const BoxConstraints(
                          maxWidth: 500,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              isAdmin
                                  ? Colors.blue
                                  : isAi
                                      ? Colors.purple
                                      : Colors.white10,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              msg['senderName'] ??
                                  '',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(
                                height: 6),

                            Text(
                              msg['message'] ??
                                  '',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,

                                fontSize: 15,
                              ),
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

          Container(
            padding:
                const EdgeInsets.all(16),

            color:
                const Color(0xFF111827),

            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller:
                        _messageController,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(
                      hintText:
                          'Reply as admin...',

                      hintStyle:
                          const TextStyle(
                        color:
                            Colors.white54,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white10,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed:
                      _sendMessage,

                  child:
                      const Text(
                    "Send",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}