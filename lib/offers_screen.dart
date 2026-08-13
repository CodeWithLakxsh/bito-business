// ============================================================
// offers_screen.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'create_coupon_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,

        title: const Text(
          "Offers & Coupons",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Align(
                alignment: Alignment.centerRight,

                child: SizedBox(
                  height: 50,
                  width: 220,

                  child: ElevatedButton.icon(
                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const CreateCouponScreen(),
                        ),
                      );
                    },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.orange,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),

                    label: const Text(
                      "Create Coupon",

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: StreamBuilder<
                    QuerySnapshot>(
                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                              'offers')
                          .orderBy(
                            'created_at',
                            descending: true,
                          )
                          .snapshots(),

                  builder:
                      (context, snapshot) {

                    if (snapshot.hasError) {

                      return Center(
                        child: Text(
                          snapshot.error.toString(),

                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

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

                      return Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            Icon(
                              Icons.local_offer,
                              size: 80,
                              color: Colors.white
                                  .withOpacity(0.2),
                            ),

                            const SizedBox(
                                height: 20),

                            const Text(
                              "No Offers Found",

                              style: TextStyle(
                                color:
                                    Colors.white70,

                                fontSize: 20,

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            SizedBox(
                              width: 220,
                              height: 50,

                              child:
                                  ElevatedButton.icon(
                                onPressed: () {

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CreateCouponScreen(),
                                    ),
                                  );
                                },

                                icon: const Icon(
                                  Icons.add,
                                ),

                                label: const Text(
                                  "Create First Offer",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final coupons =
                        snapshot.data!.docs;

                    return ListView.builder(
                      itemCount:
                          coupons.length,

                      itemBuilder:
                          (context, index) {

                        final coupon =
                            coupons[index];

                        final isActive =
                            coupon['is_active'] ??
                                false;

                        return Container(
                          margin:
                              const EdgeInsets
                                  .only(
                            bottom: 18,
                          ),

                          padding:
                              const EdgeInsets
                                  .all(20),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withOpacity(
                              0.05,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              24,
                            ),

                            border:
                                Border.all(
                              color: Colors
                                  .white
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        Text(
                                          coupon['coupon_code'] ??
                                              '',

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors
                                                    .orange,

                                            fontSize:
                                                26,

                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                            height: 8),

                                        Text(
                                          coupon['title'] ??
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
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          14,

                                      vertical: 8,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          isActive
                                              ? Colors
                                                  .green
                                              : Colors
                                                  .red,

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        20,
                                      ),
                                    ),

                                    child: Text(
                                      isActive
                                          ? "ACTIVE"
                                          : "DISABLED",

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors
                                                .white,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 18),

                              Text(
                                coupon['subtitle'] ??
                                    '',

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white70,

                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                  height: 24),

                              Row(
                                children: [

                                  Expanded(
                                    child: SizedBox(
                                      height: 48,

                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            () async {

                                          await FirebaseFirestore
                                              .instance
                                              .collection(
                                                  'offers')
                                              .doc(
                                                  coupon.id)
                                              .update({

                                            "is_active":
                                                !isActive,
                                          });
                                        },

                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              isActive
                                                  ? Colors
                                                      .orange
                                                  : Colors
                                                      .green,
                                        ),

                                        child: Text(
                                          isActive
                                              ? "Disable"
                                              : "Activate",
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 14),

                                  Expanded(
                                    child: SizedBox(
                                      height: 48,

                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            () async {

                                          final confirm =
                                              await showDialog(
                                            context:
                                                context,

                                            builder:
                                                (context) {

                                              return AlertDialog(
                                                backgroundColor:
                                                    const Color(
                                                        0xFF111827),

                                                title:
                                                    const Text(
                                                  "Delete Offer",

                                                  style: TextStyle(
                                                    color:
                                                        Colors.white,
                                                  ),
                                                ),

                                                content:
                                                    const Text(
                                                  "Are you sure you want to delete this offer?",

                                                  style: TextStyle(
                                                    color:
                                                        Colors.white70,
                                                  ),
                                                ),

                                                actions: [

                                                  TextButton(
                                                    onPressed:
                                                        () {

                                                      Navigator.pop(
                                                          context,
                                                          false);
                                                    },

                                                    child:
                                                        const Text(
                                                      "Cancel",
                                                    ),
                                                  ),

                                                  ElevatedButton(
                                                    onPressed:
                                                        () {

                                                      Navigator.pop(
                                                          context,
                                                          true);
                                                    },

                                                    style:
                                                        ElevatedButton
                                                            .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),

                                                    child:
                                                        const Text(
                                                      "Delete",
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirm ==
                                              true) {

                                            await FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'offers')
                                                .doc(
                                                    coupon.id)
                                                .delete();
                                          }
                                        },

                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              Colors.red,
                                        ),

                                        child:
                                            const Text(
                                          "Delete",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}