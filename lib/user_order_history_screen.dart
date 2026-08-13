import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserOrderHistoryScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const UserOrderHistoryScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  Color _statusColor(String status) {
    switch (status) {

      case 'completed':
      case 'delivered':
        return Colors.green;

      case 'cancelled':
      case 'canceled':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.blue;
    }
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
          "$userName Orders",
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('orders')
                .where(
                  'userId',
                  isEqualTo: userId,
                )
                .orderBy(
                  'createdAt',
                  descending: true,
                )
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

          if (!snapshot.hasData ||
              snapshot.data!.docs
                  .isEmpty) {

            return const Center(
              child: Text(
                "No Orders Found",

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            );
          }

          final orders =
              snapshot.data!.docs;

          return ListView.builder(
            padding:
                const EdgeInsets.all(
              24,
            ),

            itemCount:
                orders.length,

            itemBuilder:
                (context, index) {

              final order =
                  orders[index];

              final data =
                  order.data()
                      as Map<String,
                          dynamic>;

              final status =
                  data['status'] ??
                      'pending';

              final totalPaise =
                  (data['totalPaise'] ??
                          0)
                      as num;

              final items =
                  data['items'] ??
                      [];

              final createdAt =
                  data['createdAt'];

              String formattedDate =
                  'Unknown';

              if (createdAt
                  is Timestamp) {

                final date =
                    createdAt.toDate();

                formattedDate =
                    "${date.day}/${date.month}/${date.year}";
              }

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 20,
                ),

                padding:
                    const EdgeInsets.all(
                  22,
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
                            data['vendorName'] ??
                                'Unknown Vendor',

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 22,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 14,
                            vertical: 7,
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
                            status
                                .toUpperCase(),

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
                        height: 14),

                    Text(
                      "Order ID: ${order.id}",

                      style:
                          const TextStyle(
                        color:
                            Colors.white54,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    Text(
                      "Date: $formattedDate",

                      style:
                          const TextStyle(
                        color:
                            Colors.white54,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    Text(
                      "Total Paid: ₹${(totalPaise / 100).toStringAsFixed(0)}",

                      style:
                          const TextStyle(
                        color:
                            Colors.white,

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                    const Text(
                      "Items",

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    ...items.map<Widget>(
                      (item) {

                        return Container(
                          margin:
                              const EdgeInsets
                                  .only(
                            bottom: 10,
                          ),

                          padding:
                              const EdgeInsets
                                  .all(14),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withOpacity(
                              0.04,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                          ),

                          child: Row(
                            children: [

                              Expanded(
                                child: Text(
                                  item['name'] ??
                                      '',

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),

                              Text(
                                "x${item['quantity'] ?? 1}",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}