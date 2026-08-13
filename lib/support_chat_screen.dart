import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'telegram_service.dart';

class SupportChatScreen extends StatefulWidget {
  final String ticketId;
  final String userName;

  const SupportChatScreen({
    super.key,
    required this.ticketId,
    required this.userName,
  });

  @override
  State<SupportChatScreen> createState() =>
      _SupportChatScreenState();
}

class _SupportChatScreenState
    extends State<SupportChatScreen> {

  final TextEditingController
      _messageController =
          TextEditingController();

  Future<void> _sendMessage() async {
    final text =
        _messageController.text.trim();

    if (text.isEmpty) return;

    _messageController.clear();

    await FirebaseFirestore.instance
        .collection('support_messages')
        .add({
      "ticketId": widget.ticketId,

      "senderId": "admin",

      "senderName": "Biteo Support",

      "senderType": "admin",

      "message": text,

      "createdAt":
          FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('support_tickets')
        .doc(widget.ticketId)
        .update({
      "lastMessage": text,
      "updatedAt":
          FieldValue.serverTimestamp(),
      "status": "pending",
    });
    await TelegramService.sendMessage(
  '''
💬 ADMIN REPLIED

👤 User:
${widget.userName}

🎫 Ticket ID:
${widget.ticketId}

📝 Reply:
$text

''',
);
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

        title: Text(widget.userName),
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
                          'support_messages')
                      .where(
                        'ticketId',
                        isEqualTo:
                            widget.ticketId,
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

                    final isAdmin =
                        msg['senderType'] ==
                            'admin';

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
                          maxWidth: 450,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              isAdmin
                                  ? Colors
                                      .blue
                                  : Colors
                                      .white10,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                        ),

                        child: Text(
                          msg['message'],
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),
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
                          'Type message...',

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