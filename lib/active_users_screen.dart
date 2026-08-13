import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActiveUsersScreen extends StatelessWidget {
  const ActiveUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Active Users",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // ─────────────────────────────
                    // LOADING
                    // ─────────────────────────────
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // ─────────────────────────────
                    // ERROR
                    // ─────────────────────────────
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    // ─────────────────────────────
                    // EMPTY
                    // ─────────────────────────────
                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Users Found",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final users = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        try {
                          final user = users[index];

                          final rawData = user.data();

                          final data =
                              rawData is Map<String, dynamic>
                                  ? rawData
                                  : <String, dynamic>{};

                          // ─────────────────────────────
                          // SAFE DATA
                          // ─────────────────────────────
                          final photoUrl =
                              (data['photoUrl'] ?? '')
                                  .toString()
                                  .trim();

                          final name =
                              (data['name'] ?? 'No Name')
                                  .toString()
                                  .trim();

                          final email =
                              (data['email'] ?? '')
                                  .toString()
                                  .trim();

                          final isBlocked =
                              data['isBlocked'] == true;

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 18,
                            ),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(
                                0.05,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                24,
                              ),
                              border: Border.all(
                                color: Colors.white
                                    .withOpacity(
                                  0.08,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // ─────────────────────────────
                                // PROFILE IMAGE
                                // ─────────────────────────────
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Colors.white12,
                                  backgroundImage:
                                      photoUrl.isNotEmpty
                                          ? NetworkImage(
                                              photoUrl,
                                            )
                                          : null,
                                  child: photoUrl.isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          color:
                                              Colors.white,
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 18),

                                // ─────────────────────────────
                                // USER INFO
                                // ─────────────────────────────
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        name.isEmpty
                                            ? 'No Name'
                                            : name,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      Text(
                                        email.isEmpty
                                            ? 'No Email'
                                            : email,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // ─────────────────────────────
                                // SAFE BUTTON
                                // ─────────────────────────────
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius
                                            .circular(12),
                                    onTap: () async {
                                      try {
                                        await FirebaseFirestore
                                            .instance
                                            .collection(
                                                'users')
                                            .doc(user.id)
                                            .update({
                                          "isBlocked":
                                              !isBlocked,
                                        });

                                        if (context
                                            .mounted) {
                                          ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                !isBlocked
                                                    ? 'User blocked'
                                                    : 'User unblocked',
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint(
                                          'BLOCK USER ERROR: $e',
                                        );

                                        if (context
                                            .mounted) {
                                          ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Error: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 46,
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 18,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: isBlocked
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          12,
                                        ),
                                      ),
                                      alignment:
                                          Alignment.center,
                                      child: Text(
                                        isBlocked
                                            ? 'Unblock'
                                            : 'Block',
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
                                  ),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          debugPrint(
                            'USER CARD ERROR: $e',
                          );

                          return Container(
                            margin:
                                const EdgeInsets.only(
                              bottom: 16,
                            ),
                            padding:
                                const EdgeInsets.all(
                              16,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Colors.red.withOpacity(
                                0.08,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                            child: Text(
                              'Error loading user',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}