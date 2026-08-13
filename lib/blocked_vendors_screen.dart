import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedVendorsScreen extends StatelessWidget {
  const BlockedVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1020),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Blocked Vendors",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vendors')
                  .where('isActive', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Blocked Vendors",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final vendors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendor =
                        vendors[index];

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      padding:
                          const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage:
                                vendor['imageUrl'] != ""
                                    ? NetworkImage(
                                        vendor['imageUrl'],
                                      )
                                    : null,
                            backgroundColor:
                                Colors.white12,
                            child:
                                vendor['imageUrl'] == ""
                                    ? const Icon(
                                        Icons.store,
                                        color:
                                            Colors.white,
                                      )
                                    : null,
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  vendor['businessName'] ??
                                      '',
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
                                    height: 6),

                                Text(
                                  vendor['category'] ??
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
                                  vendor['city'] ?? '',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore
                                  .instance
                                  .collection(
                                      'vendors')
                                  .doc(vendor.id)
                                  .update({
                                "isActive": true,
                              });
                            },
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green,
                            ),
                            child: const Text(
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