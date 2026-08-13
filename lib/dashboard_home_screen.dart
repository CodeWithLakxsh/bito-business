import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'earnings_screen.dart';
import 'offers_screen.dart';
import 'notification_sender_screen.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1020),
      padding: const EdgeInsets.all(24),

      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final vendors =
              snapshot.data?.docs ?? [];

          final totalVendors =
              vendors.length;

          final activeVendors = vendors
              .where(
                (e) =>
                    e['isActive'] == true,
              )
              .length;

          final blockedVendors = vendors
              .where(
                (e) =>
                    e['isActive'] == false,
              )
              .length;

          final openRestaurants = vendors
              .where(
                (e) =>
                    e['isCurrentlyOpen'] ==
                    true,
              )
              .length;

         return SingleChildScrollView(
  child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(
                    "Dashboard",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Row(
                    children: [

                      ElevatedButton.icon(
                        onPressed: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const EarningsScreen(),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange,
                          minimumSize:
                              const Size(
                            180,
                            54,
                          ),
                        ),

                        icon: const Icon(
                          Icons
                              .analytics_rounded,
                        ),

                        label: const Text(
                          "Analytics",
                        ),
                      ),

                      const SizedBox(
                          width: 16),

                      ElevatedButton.icon(
                        onPressed: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const OffersScreen(),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.purple,
                          minimumSize:
                              const Size(
                            220,
                            54,
                          ),
                        ),

                        icon: const Icon(
                          Icons
                              .local_offer_rounded,
                        ),

                        label: const Text(
                          "Offers & Coupons",
                        ),
                      ),

                      const SizedBox(
                          width: 16),

                      // 🔥 NEW NOTIFICATION BUTTON

                      ElevatedButton.icon(
                        onPressed: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
    const NotificationSenderScreen(),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.cyan,
                          minimumSize:
                              const Size(
                            200,
                            54,
                          ),
                        ),

                        icon: const Icon(
                          Icons
                              .notifications_active,
                        ),

                        label: const Text(
                          "Notifications",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Wrap(
                spacing: 20,
                runSpacing: 20,

                children: [

                  dashboardCard(
                    title: "Total Vendors",

                    value:
                        totalVendors.toString(),

                    icon:
                        Icons.storefront_rounded,

                    color:
                        Colors.orange,
                  ),

                  dashboardCard(
                    title: "Active Vendors",

                    value:
                        activeVendors.toString(),

                    icon:
                        Icons.check_circle,

                    color:
                        Colors.green,
                  ),

                  dashboardCard(
                    title:
                        "Blocked Vendors",

                    value:
                        blockedVendors
                            .toString(),

                    icon: Icons.block,

                    color: Colors.red,
                  ),

                  dashboardCard(
                    title:
                        "Restaurants Open",

                    value:
                        openRestaurants
                            .toString(),

                    icon:
                        Icons.restaurant,

                    color:
                        Colors.blue,
                  ),

                  // 🔥 ANALYTICS CARD

                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const EarningsScreen(),
                        ),
                      );
                    },

                    child: Container(
                      width: 260,

                      padding:
                          const EdgeInsets.all(
                        24,
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

                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Icon(
                            Icons
                                .analytics_rounded,

                            color:
                                Colors.orange,

                            size: 36,
                          ),

                          SizedBox(height: 20),

                          Text(
                            "Realtime Analytics",

                            style: TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 26,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "View earnings, GMV, profits and daily analytics.",

                            style: TextStyle(
                              color:
                                  Colors.white70,

                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔥 OFFERS CARD

                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const OffersScreen(),
                        ),
                      );
                    },

                    child: Container(
                      width: 260,

                      padding:
                          const EdgeInsets.all(
                        24,
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

                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Icon(
                            Icons
                                .local_offer_rounded,

                            color:
                                Colors.purple,

                            size: 36,
                          ),

                          SizedBox(height: 20),

                          Text(
                            "Offers & Coupons",

                            style: TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 24,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Create and manage all offers & coupons.",

                            style: TextStyle(
                              color:
                                  Colors.white70,

                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔥 NOTIFICATIONS CARD

                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                         builder: (_) =>
    const NotificationSenderScreen(),
                        ),
                      );
                    },

                    child: Container(
                      width: 260,

                      padding:
                          const EdgeInsets.all(
                        24,
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

                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Icon(
                            Icons
                                .notifications_active,

                            color:
                                Colors.cyan,

                            size: 36,
                          ),

                          SizedBox(height: 20),

                          Text(
                            "Notifications",

                            style: TextStyle(
                              color:
                                  Colors.white,

                              fontSize: 24,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Send push notifications to users and vendors.",

                            style: TextStyle(
                              color:
                                  Colors.white70,

                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Recently Added Vendors",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListView.builder(
  shrinkWrap: true,
  physics:
      const NeverScrollableScrollPhysics(),
                  itemCount:
                      vendors.length > 5
                          ? 5
                          : vendors.length,

                  itemBuilder:
                      (context, index) {

                    final vendor =
                        vendors[index];

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                          const EdgeInsets.all(
                        18,
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
                          20,
                        ),
                      ),

                      child: Row(
                        children: [

                          Container(
                            width: 56,
                            height: 56,

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.white12,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                100,
                              ),
                            ),

                            clipBehavior:
                                Clip.antiAlias,

                            child: vendor[
                                            'imageUrl'] !=
                                        null &&
                                    vendor[
                                            'imageUrl']
                                        .toString()
                                        .isNotEmpty
                                ? Image.network(
                                    vendor[
                                        'imageUrl'],

                                    fit:
                                        BoxFit.cover,

                                    loadingBuilder:
                                        (
                                      context,
                                      child,
                                      progress,
                                    ) {

                                      if (progress ==
                                          null) {
                                        return child;
                                      }

                                      return const Center(
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,
                                        ),
                                      );
                                    },

                                    errorBuilder:
                                        (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {

                                      print(
                                        "DASHBOARD IMAGE ERROR: $error",
                                      );

                                      print(
                                        "IMAGE URL: ${vendor['imageUrl']}",
                                      );

                                      return const Icon(
                                        Icons.store,
                                        color: Colors
                                            .white,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.store,
                                    color:
                                        Colors.white,
                                  ),
                          ),

                          const SizedBox(
                              width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  vendor[
                                          'businessName'] ??
                                      '',

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors
                                            .white,

                                    fontSize:
                                        18,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 6),

                                Text(
                                  vendor[
                                          'category'] ??
                                      '',

                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .white70,
                                  ),
                                ),
                              ],
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
                              color: vendor[
                                          'isActive'] ==
                                      true
                                  ? Colors.green
                                  : Colors.red,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),

                            child: Text(
                              vendor['isActive'] ==
                                      true
                                  ? "ACTIVE"
                                  : "BLOCKED",

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
                        ],
                      ),
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

  Widget dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {

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

          Icon(
            icon,
            color: color,
            size: 36,
          ),

          const SizedBox(height: 20),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
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