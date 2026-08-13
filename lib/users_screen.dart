import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user_detail_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

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
            "All Users",

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
                      .collection('users')
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
                      "No Users Found",

                      style: TextStyle(
                        color:
                            Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final users =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount:
                      users.length,

                  itemBuilder:
                      (context, index) {

                    final user =
                        users[index];

                    final isBlocked =
                        user['isBlocked'] ??
                            false;

                    return GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                UserDetailScreen(
                              userId:
                                  user.id,
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

                        child: Row(
                          children: [

                            CircleAvatar(
                              radius: 30,

                              backgroundImage:
                                  (user['photoUrl'] ??
                                              '')
                                          .toString()
                                          .isNotEmpty
                                      ? NetworkImage(
                                          user[
                                              'photoUrl'],
                                        )
                                      : null,

                              backgroundColor:
                                  Colors.white12,

                              child:
                                  (user['photoUrl'] ??
                                              '')
                                          .toString()
                                          .isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          color:
                                              Colors.white,
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

                                  Row(
                                    children: [

                                      Expanded(
                                        child: Text(
                                          user['name'] ??
                                              '',

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
                                          horizontal:
                                              12,

                                          vertical:
                                              6,
                                        ),

                                        decoration:
                                            BoxDecoration(
                                          color:
                                              isBlocked
                                                  ? Colors.red
                                                  : Colors.green,

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(
                                          isBlocked
                                              ? 'BLOCKED'
                                              : 'ACTIVE',

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
                                      height: 8),

                                  Text(
                                    user['email'] ??
                                        '',

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 6),

                                  Text(
                                    user['phone'] ??
                                        '',

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white54,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 12),

                                  Row(
                                    children: [

                                      const Icon(
                                        Icons.workspace_premium_rounded,
                                        color:
                                            Colors.amber,
                                        size: 18,
                                      ),

                                      const SizedBox(
                                          width: 6),

                                      Text(
                                        "${user['biteoPoints'] ?? 0} Points",

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
        ],
      ),
    );
  }
}