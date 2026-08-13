import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActiveVendorsScreen extends StatelessWidget {
  const ActiveVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1020),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Active Vendors",
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
                  .collection('vendors')
                  .where(
                    'isActive',
                    isEqualTo: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

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

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Active Vendors",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final vendors = snapshot.data!.docs;

                return GridView.builder(
                  itemCount: vendors.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final vendor = vendors[index];

                    final data =
                        vendor.data() as Map<String, dynamic>;

                    final imageUrl =
                        (data['imageUrl'] ?? '')
                            .toString();

                    final businessName =
                        (data['businessName'] ?? '')
                            .toString();

                    final category =
                        (data['category'] ?? '')
                            .toString();

                    final city =
                        (data['city'] ?? '')
                            .toString();

                    final phone =
                        (data['phoneNumber'] ?? '')
                            .toString();

                    final isOpen =
                        data['isCurrentlyOpen'] ?? false;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
  width: 68,
  height: 68,
  decoration: BoxDecoration(
    color: Colors.white12,
    borderRadius: BorderRadius.circular(100),
  ),
  clipBehavior: Clip.antiAlias,
  child: imageUrl.isNotEmpty
      ? Image.network(
          imageUrl,
          fit: BoxFit.cover,

         errorBuilder:
    (
  context,
  error,
  stackTrace,
) {

  print("IMAGE ERROR: $error");

  return const Icon(
    Icons.store,
    color: Colors.white,
    size: 30,
  );
},

          loadingBuilder:
              (
            context,
            child,
            progress,
          ) {
            if (progress == null) {
              return child;
            }

            return const Center(
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        )
      : const Icon(
          Icons.store,
          color: Colors.white,
          size: 30,
        ),
),

                              const Spacer(),

                              PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "block",
                                    child: Text(
                                      "Block Vendor",
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == "block") {
                                    await FirebaseFirestore
                                        .instance
                                        .collection('vendors')
                                        .doc(vendor.id)
                                        .update({
                                      "isActive": false,
                                    });
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            businessName,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            category,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white54,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  city,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white54,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  phone,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          backgroundColor:
                                              const Color(
                                            0xFF111827,
                                          ),
                                          title: Text(
                                            businessName,
                                            style:
                                                const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize:
                                                MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                "Category: $category",
                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Colors.white70,
                                                ),
                                              ),

                                              const SizedBox(
                                                  height: 10),

                                              Text(
                                                "City: $city",
                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Colors.white70,
                                                ),
                                              ),

                                              const SizedBox(
                                                  height: 10),

                                              Text(
                                                "Phone: $phone",
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
                                    );
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xFFFF5A5F,
                                    ),
                                  ),
                                  child: const Text(
                                    "View",
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore
                                        .instance
                                        .collection('vendors')
                                        .doc(vendor.id)
                                        .update({
                                      "isCurrentlyOpen":
                                          !isOpen,
                                    });
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isOpen
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  child: Text(
                                    isOpen
                                        ? "Open"
                                        : "Closed",
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
    );
  }
}