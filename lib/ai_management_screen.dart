import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AiManagementScreen extends StatefulWidget {
  const AiManagementScreen({super.key});

  @override
  State<AiManagementScreen> createState() =>
      _AiManagementScreenState();
}

class _AiManagementScreenState
    extends State<AiManagementScreen> {

  final TextEditingController
      _promptController =
          TextEditingController();

  final TextEditingController
      _escalationController =
          TextEditingController();

  final TextEditingController
      _blockedController =
          TextEditingController();

  bool _isAiEnabled = true;

  Future<void> _saveSettings() async {

    await FirebaseFirestore.instance
        .collection('ai_settings')
        .doc('main')
        .set({

      "isAiEnabled":
          _isAiEnabled,

      "systemPrompt":
          _promptController.text.trim(),

      "escalationKeywords":
          _escalationController.text
              .split(','),

      "blockedKeywords":
          _blockedController.text
              .split(','),

      "updatedAt":
          FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "AI Settings Updated",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(0xFF0B1020),

      padding: const EdgeInsets.all(24),

      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ai_settings')
            .doc('main')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>?;

          _isAiEnabled =
              data?['isAiEnabled'] ?? true;

          _promptController.text =
              data?['systemPrompt'] ?? '';

          _escalationController.text =
              (data?['escalationKeywords']
                          as List?)
                      ?.join(', ') ??
                  '';

          _blockedController.text =
              (data?['blockedKeywords']
                          as List?)
                      ?.join(', ') ??
                  '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  "AI Chatbot Management",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.05,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      SwitchListTile(
                        value: _isAiEnabled,

                        onChanged: (value) {

                          setState(() {
                            _isAiEnabled =
                                value;
                          });
                        },

                        activeColor:
                            Colors.green,

                        title: const Text(
                          "Enable AI Chatbot",

                          style: TextStyle(
                            color:
                                Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 24),

                      const Text(
                        "System Prompt",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      TextField(
                        controller:
                            _promptController,

                        maxLines: 6,

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            const InputDecoration(
                          hintText:
                              "Enter AI system prompt",
                        ),
                      ),

                      const SizedBox(
                          height: 24),

                      const Text(
                        "Escalation Keywords",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      TextField(
                        controller:
                            _escalationController,

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            const InputDecoration(
                          hintText:
                              "refund, angry, human",
                        ),
                      ),

                      const SizedBox(
                          height: 24),

                      const Text(
                        "Blocked Keywords",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      TextField(
                        controller:
                            _blockedController,

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            const InputDecoration(
                          hintText:
                              "hack, abuse",
                        ),
                      ),

                      const SizedBox(
                          height: 30),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed:
                              _saveSettings,

                          child: const Text(
                            "Save AI Settings",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "AI Analytics",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                              'ai_chats')
                          .snapshots(),

                  builder:
                      (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    final chats =
                        snapshot.data!.docs;

                    final totalChats =
                        chats.length;

                    final escalated =
                        chats.where(
                      (e) =>
                          e[
                              'representativeRequested'] ==
                          true,
                    ).length;

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,

                      children: [

                        analyticsCard(
                          "Total AI Chats",
                          totalChats
                              .toString(),
                          Colors.blue,
                        ),

                        analyticsCard(
                          "Escalations",
                          escalated
                              .toString(),
                          Colors.red,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget analyticsCard(
    String title,
    String value,
    Color color,
  ) {

    return Container(
      width: 260,

      padding:
          const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.05),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: Colors.white
              .withOpacity(0.08),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            value,

            style: TextStyle(
              color: color,
              fontSize: 34,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}