import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF111827),

        title: const Text(
          "Earnings & Analytics",
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('orders')
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

          if (!snapshot.hasData) {

            return const Center(
              child: Text(
                "No Analytics Found",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final orders =
              snapshot.data!.docs;

          // ─────────────────────────
          // LIFETIME
          // ─────────────────────────

          int totalOrders = 0;
          int completedOrders = 0;
          int cancelledOrders = 0;

          double totalRevenue = 0;
          double totalPlatformProfit = 0;

          // ─────────────────────────
          // DAILY
          // ─────────────────────────

          int todayOrders = 0;
          int todayCompleted = 0;
          int todayCancelled = 0;

          double todayRevenue = 0;
          double todayProfit = 0;

          final now = DateTime.now();

          for (final order
              in orders) {

            final data =
                order.data()
                    as Map<String,
                        dynamic>;

            totalOrders++;

            final status =
                data['status'] ?? '';

            final totalPaise =
                (data['totalPaise'] ??
                        0)
                    as num;

            final platformFeePaise =
                (data['platformFeePaise'] ??
                        0)
                    as num;

            totalRevenue +=
                totalPaise / 100;

            totalPlatformProfit +=
                platformFeePaise /
                    100;

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

            // ─────────────────────
            // TODAY ANALYTICS
            // ─────────────────────

            final createdAt =
                data['createdAt'];

            if (createdAt
                is Timestamp) {

              final date =
                  createdAt
                      .toDate();

              final isToday =
                  date.year ==
                          now.year &&
                      date.month ==
                          now.month &&
                      date.day ==
                          now.day;

              if (isToday) {

                todayOrders++;

                todayRevenue +=
                    totalPaise /
                        100;

                todayProfit +=
                    platformFeePaise /
                        100;

                if (status ==
                        'completed' ||
                    status ==
                        'delivered') {

                  todayCompleted++;
                }

                if (status ==
                        'cancelled' ||
                    status ==
                        'canceled') {

                  todayCancelled++;
                }
              }
            }
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

                const Text(
                  "Lifetime Analytics",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 30,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 24),

                Wrap(
                  spacing: 18,
                  runSpacing: 18,

                  children: [

                    _card(
                      "Total Orders",
                      totalOrders
                          .toString(),
                    ),

                    _card(
                      "Completed",
                      completedOrders
                          .toString(),
                    ),

                    _card(
                      "Cancelled",
                      cancelledOrders
                          .toString(),
                    ),

                    _card(
                      "GMV",
                      "₹${totalRevenue.toStringAsFixed(0)}",
                    ),

                    _card(
                      "Platform Profit",
                      "₹${totalPlatformProfit.toStringAsFixed(0)}",
                    ),
                  ],
                ),

                const SizedBox(
                    height: 50),

                const Text(
                  "Today's Analytics",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 30,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 24),

                Wrap(
                  spacing: 18,
                  runSpacing: 18,

                  children: [

                    _card(
                      "Today's Orders",
                      todayOrders
                          .toString(),
                    ),

                    _card(
                      "Today's Completed",
                      todayCompleted
                          .toString(),
                    ),

                    _card(
                      "Today's Cancelled",
                      todayCancelled
                          .toString(),
                    ),

                    _card(
                      "Today's Revenue",
                      "₹${todayRevenue.toStringAsFixed(0)}",
                    ),

                    _card(
                      "Today's Profit",
                      "₹${todayProfit.toStringAsFixed(0)}",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(
    String title,
    String value,
  ) {

    return Container(
      width: 250,

      padding:
          const EdgeInsets.all(24),

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
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,

              fontSize: 30,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}