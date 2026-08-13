import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinRequestsScreen extends StatelessWidget {
  const JoinRequestsScreen({super.key});

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
            "Vendor Join Requests",
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
                  .collection(
                      'vendor_join_requests')
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
                      "No Join Requests",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final requests =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder:
                      (context, index) {
                    final request =
                        requests[index];

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
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            request[
                                    'businessName'] ??
                                '',
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          Text(
                            "Owner: ${request['ownerName'] ?? ''}",
                            style:
                                const TextStyle(
                              color: Colors
                                  .white70,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            "Phone: ${request['phoneNumber'] ?? ''}",
                            style:
                                const TextStyle(
                              color: Colors
                                  .white70,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            "City: ${request['city'] ?? ''}",
                            style:
                                const TextStyle(
                              color: Colors
                                  .white70,
                            ),
                          ),

                          const SizedBox(
                              height: 24),

                          Row(
                            children: [
                              ElevatedButton(
                                onPressed:
                                    () async {
                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                          'vendor_join_requests')
                                      .doc(request
                                          .id)
                                      .update({
                                    "status":
                                        "approved",
                                  });
                                },
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors
                                          .green,
                                ),
                                child:
                                    const Text(
                                  "Approve",
                                ),
                              ),

                              const SizedBox(
                                  width: 14),

                              ElevatedButton(
                                onPressed:
                                    () async {
                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                          'vendor_join_requests')
                                      .doc(request
                                          .id)
                                      .update({
                                    "status":
                                        "rejected",
                                  });
                                },
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red,
                                ),
                                child:
                                    const Text(
                                  "Reject",
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
    );
  }
}