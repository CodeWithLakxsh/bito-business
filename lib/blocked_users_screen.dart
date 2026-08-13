import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

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
            "Blocked Users",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'isBlocked',
                    isEqualTo: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Blocked Users",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final users =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder:
                      (context, index) {
                    final user =
                        users[index];

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
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                user['photoUrl'] !=
                                            ""
                                    ? NetworkImage(
                                        user[
                                            'photoUrl'],
                                      )
                                    : null,
                            backgroundColor:
                                Colors.white12,
                            child: user[
                                        'photoUrl'] ==
                                    ""
                                ? const Icon(
                                    Icons.person,
                                    color: Colors
                                        .white,
                                  )
                                : null,
                          ),

                          const SizedBox(
                              width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  user['name'] ??
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

                                const SizedBox(
                                    height: 6),

                                Text(
                                  user['email'] ??
                                      '',
                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .white70,
                                  ),
                                ),

                                const SizedBox(
                                    height: 6),

                                Text(
                                  user['phone'] ??
                                      '',
                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .white54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ElevatedButton(
                            onPressed:
                                () async {
                              await FirebaseFirestore
                                  .instance
                                  .collection(
                                      'users')
                                  .doc(
                                      user.id)
                                  .update({
  "isBlocked": false,
  "blockedAt": null,
  "blockedReason": null,
});
                            },
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green,
                            ),
                            child:
                                const Text(
                              "Unblock",
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
    );
  }
}