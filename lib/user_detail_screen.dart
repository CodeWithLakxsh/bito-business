import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'telegram_service.dart';
import 'user_order_history_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final String userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF111827),

        title: const Text(
          "User Details",
        ),
      ),

      body: StreamBuilder<
          DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),

        builder:
            (context, userSnapshot) {

          if (!userSnapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final user =
              userSnapshot.data!;

          final data =
              user.data()
                  as Map<String, dynamic>?;

          if (data == null) {

            return const Center(
              child: Text(
                "User not found",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final isBlocked =
              data['isBlocked'] ?? false;

          return StreamBuilder<
              QuerySnapshot>(
            stream:
                FirebaseFirestore
                    .instance
                    .collection('orders')
                    .where(
                      'userId',
                      isEqualTo: userId,
                    )
                    .snapshots(),

            builder:
                (context, orderSnapshot) {

              int totalOrders = 0;
              int completedOrders = 0;
              int cancelledOrders = 0;

              double totalSpent = 0;

              final Map<String, int>
                  itemFrequency = {};

              if (orderSnapshot.hasData) {

                final orders =
                    orderSnapshot
                        .data!
                        .docs;

                totalOrders =
                    orders.length;

                for (final order
                    in orders) {

                  final orderData =
                      order.data()
                          as Map<String,
                              dynamic>;

                  final status =
                      orderData[
                              'status'] ??
                          '';

                  if (status ==
                          'completed' ||
                      status ==
                          'delivered') {
                    completedOrders++;
                  }

                  if (status ==
                          'cancelled' ||
                      status ==
                          'canceled') {
                    cancelledOrders++;
                  }

                  final total =
                      (orderData[
                                      'totalPaise'] ??
                                  0)
                              as num;

                  totalSpent +=
                      total / 100;

                  final items =
                      orderData[
                              'items'] ??
                          [];

                  for (final item
                      in items) {

                    final name =
                        item['name'] ??
                            '';

                    itemFrequency[
                            name] =
                        (itemFrequency[
                                    name] ??
                                0) +
                            1;
                  }
                }
              }

              String mostOrdered =
                  'N/A';

              if (itemFrequency
                  .isNotEmpty) {

                mostOrdered =
                    itemFrequency.entries
                        .reduce(
                          (a, b) =>
                              a.value >
                                      b.value
                                  ? a
                                  : b,
                        )
                        .key;
              }

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                  24,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Center(
                      child: Column(
                        children: [

                          CircleAvatar(
                            radius: 50,

                            backgroundImage:
                                (data['photoUrl'] ??
                                            '')
                                        .toString()
                                        .isNotEmpty
                                    ? NetworkImage(
                                        data[
                                            'photoUrl'],
                                      )
                                    : null,

                            backgroundColor:
                                Colors.white12,

                            child:
                                (data['photoUrl'] ??
                                            '')
                                        .toString()
                                        .isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color:
                                            Colors.white,

                                        size: 40,
                                      )
                                    : null,
                          ),

                          const SizedBox(
                              height: 18),

                          Text(
                            data['name'] ??
                                '',

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 30,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                              height: 8),

                          Text(
                            data['email'] ??
                                '',

                            style:
                                const TextStyle(
                              color:
                                  Colors.white70,

                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            data['phone'] ??
                                '',

                            style:
                                const TextStyle(
                              color:
                                  Colors.white54,

                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 32),

                    Wrap(
                      spacing: 18,
                      runSpacing: 18,

                      children: [

                        _analyticsCard(
                          "Total Orders",
                          totalOrders
                              .toString(),
                        ),

                        _analyticsCard(
                          "Completed",
                          completedOrders
                              .toString(),
                        ),

                        _analyticsCard(
                          "Cancelled",
                          cancelledOrders
                              .toString(),
                        ),

                        _analyticsCard(
                          "Spent",
                          "₹${totalSpent.toStringAsFixed(0)}",
                        ),

                        _analyticsCard(
                          "Biteo Points",
                          "${data['biteoPoints'] ?? 0}",
                        ),

                        _analyticsCard(
                          "Most Ordered",
                          mostOrdered,
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 32),

                    Container(
                      padding:
                          const EdgeInsets
                              .all(24),

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

                          const Text(
                            "Account Actions",

                            style:
                                TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 24,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                              height: 24),

                          Row(
                            children: [

                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed:
                                      () async {

                                    await FirebaseFirestore
                                        .instance
                                        .collection(
                                            'users')
                                        .doc(
                                            userId)
                                        .update({
                                      "isBlocked":
                                          !isBlocked,

                                      "blockedAt":
                                          !isBlocked
                                              ? FieldValue.serverTimestamp()
                                              : null,

                                      "blockedReason":
                                          !isBlocked
                                              ? "Blocked by admin"
                                              : null,
                                    });

                                    await TelegramService.sendMessage(
                                      '''
${!isBlocked ? '⛔ USER BLOCKED' : '✅ USER UNBLOCKED'}

👤 User:
${data['name'] ?? ''}

📧 Email:
${data['email'] ?? ''}

🆔 User ID:
$userId

''',
                                    );

                                    if (context
                                        .mounted) {

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(
                                            !isBlocked
                                                ? 'User blocked successfully'
                                                : 'User unblocked successfully',
                                          ),
                                        ),
                                      );
                                    }
                                  },

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        isBlocked
                                            ? Colors.green
                                            : Colors.red,
                                  ),

                                  child: Text(
                                    isBlocked
                                        ? "Unblock User"
                                        : "Block User",
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 18),

                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed:
                                      () {

                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (_) =>
                                            UserOrderHistoryScreen(
                                          userId:
                                              userId,

                                          userName:
                                              data['name'] ??
                                                  '',
                                        ),
                                      ),
                                    );
                                  },

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        Colors.blue,
                                  ),

                                  child:
                                      const Text(
                                    "View Orders",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _analyticsCard(
    String title,
    String value,
  ) {

    return Container(
      width: 220,

      padding:
          const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.05),

        borderRadius:
            BorderRadius.circular(
          24,
        ),

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
            title,

            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,

            maxLines: 2,

            overflow:
                TextOverflow.ellipsis,

            style: const TextStyle(
              color: Colors.white,

              fontSize: 24,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}