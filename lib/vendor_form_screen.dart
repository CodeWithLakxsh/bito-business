import 'dart:typed_data';
import 'dart:io';

import 'active_vendors_screen.dart';
import 'blocked_vendors_screen.dart';
import 'blocked_users_screen.dart';
import 'dashboard_home_screen.dart';
import 'join_requests_screen.dart';
import 'support_screen.dart';
import 'active_users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class VendorFormScreen extends StatefulWidget {
  const VendorFormScreen({super.key});

  @override
  State<VendorFormScreen> createState() =>
      _VendorFormScreenState();
}

class _VendorFormScreenState
    extends State<VendorFormScreen> {
  // ─────────────────────────────────────
  // CONTROLLERS
  // ─────────────────────────────────────

  final nameController =
      TextEditingController();

  final legalNameController =
      TextEditingController();

  final ownerNameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final gstController =
      TextEditingController();

  final fssaiController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final cityController =
      TextEditingController();

  final latController =
      TextEditingController();

  final lngController =
      TextEditingController();

  // ─────────────────────────────────────
  // VARIABLES
  // ─────────────────────────────────────

  XFile? imageFile;

  bool isLoading = false;

  bool isVeg = false;

  bool isCurrentlyOpen = true;

  bool isActive = true;

  // ─────────────────────────────────────
// DASHBOARD STATE
// ─────────────────────────────────────

String selectedPage = "dashboard";
@override
void dispose() {
  nameController.dispose();
  legalNameController.dispose();
  ownerNameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  phoneController.dispose();
  gstController.dispose();
  fssaiController.dispose();
  categoryController.dispose();
  addressController.dispose();
  cityController.dispose();
  latController.dispose();
  lngController.dispose();
  super.dispose();
}

  // ─────────────────────────────────────
  // PICK IMAGE
  // ─────────────────────────────────────

  Future<void> pickImage() async {
    final picked = await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        imageFile = picked;
      });
    }
  }

  // ─────────────────────────────────────
  // IMAGE UPLOAD
  // ─────────────────────────────────────

  Future<String> uploadImage(
  XFile file,
) async {
  try {
    final extension =
        file.name.split('.').last;

    final ref = FirebaseStorage
        .instance
        .ref()
        .child(
          'vendor_images/${DateTime.now().millisecondsSinceEpoch}.$extension',
        );

    UploadTask uploadTask;

    if (kIsWeb) {
      final bytes =
          await file.readAsBytes();

      uploadTask = ref.putData(
        bytes,
        SettableMetadata(
          contentType:
              'image/$extension',
        ),
      );
    } else {
      uploadTask = ref.putFile(
        File(file.path),
      );
    }

    final snapshot =
    await uploadTask.timeout(
  const Duration(seconds: 20),
);

    final url =
        await snapshot.ref
            .getDownloadURL();

    return url;
} catch (e, stackTrace) {

  debugPrint(
    'UPLOAD ERROR: $e',
  );

  debugPrint(
    'STACKTRACE: $stackTrace',
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'UPLOAD ERROR: $e',
      ),
    ),
  );

  rethrow;
}
}

  // ─────────────────────────────────────
  // CREATE VENDOR
  // ─────────────────────────────────────

  Future<void> createVendor() async {
    if (isLoading) return;

    // ─────────────────────────────────
    // VALIDATION
    // ─────────────────────────────────

    if (nameController.text
            .trim()
            .isEmpty ||
        legalNameController.text
            .trim()
            .isEmpty ||
        ownerNameController.text
            .trim()
            .isEmpty ||
        emailController.text
            .trim()
            .isEmpty ||
        passwordController.text
            .trim()
            .isEmpty ||
        phoneController.text
            .trim()
            .isEmpty ||
        gstController.text
            .trim()
            .isEmpty ||
        fssaiController.text
            .trim()
            .isEmpty ||
        categoryController.text
            .trim()
            .isEmpty ||
        addressController.text
            .trim()
            .isEmpty ||
        cityController.text
            .trim()
            .isEmpty ||
        latController.text
            .trim()
            .isEmpty ||
        lngController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    final lat = double.tryParse(
      latController.text.trim(),
    );

    final lng = double.tryParse(
      lngController.text.trim(),
    );

if (passwordController.text.trim().length < 6) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Password must be at least 6 characters",
      ),
    ),
  );

  return;
}

if (!emailController.text.trim().contains('@')) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Enter valid email",
      ),
    ),
  );

  return;
}

if (phoneController.text.trim().length < 10) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Enter valid phone number",
      ),
    ),
  );

  return;
}

if (lat == null || lng == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Invalid latitude or longitude",
      ),
    ),
  );

  return;
}

    try {
  setState(() {
    isLoading = true;
  });

  debugPrint("STEP 1 START");

      // ─────────────────────────────
      // UPLOAD IMAGE
      // ─────────────────────────────

      String imageUrl = "";

      if (imageFile != null) {

  debugPrint("STEP 2 IMAGE UPLOAD START");

  imageUrl =
      await uploadImage(
    imageFile!,
  );

  debugPrint("STEP 3 IMAGE UPLOAD DONE");
}

      // ─────────────────────────────
// CREATE VENDOR ID
// ─────────────────────────────

debugPrint("STEP 3 AUTH CREATE START");

final credential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
  email: emailController.text.trim(),
  password: passwordController.text.trim(),
);

debugPrint("STEP 4 AUTH CREATED");

debugPrint(
  "AUTH UID: ${credential.user?.uid}",
);

final uid = credential.user!.uid;

final vendorDoc = FirebaseFirestore.instance
    .collection('vendors')
    .doc(uid);

debugPrint("VENDOR UID: $uid");

      // ─────────────────────────────
      // GEO
      // ─────────────────────────────

      final geoPoint =
          GeoFirePoint(
        GeoPoint(lat, lng),
      );

      // ─────────────────────────────
      // SAVE FIRESTORE
      // EXACT STRUCTURE
      // ─────────────────────────────

debugPrint("STEP 4 FIRESTORE START");

debugPrint(
  "FIRESTORE DATA READY",
);

await vendorDoc.set({

        // ─────────────────────────
        // ROOT FIELDS
        // ─────────────────────────

        "businessName":
            nameController.text
                .trim(),

        "category":
            categoryController.text
                .trim(),

        "city":
            cityController.text
                .trim(),

        "fullAddress":
            addressController.text
                .trim(),

        "email":
            emailController.text
                .trim(),

        "phoneNumber":
            phoneController.text
                .trim(),

        "gstin":
            gstController.text
                .trim(),

        "fssaiLicense":
            fssaiController.text
                .trim(),

        "imageUrl":
            imageUrl,

        "lat": lat,

        "lng": lng,

        "isActive":
        isActive,

      "isCurrentlyOpen":
       isCurrentlyOpen,

      "acceptingOrders": true,

      "busyMode": false,

        // ─────────────────────────
        // GEO
        // ─────────────────────────

        "geo": {
          "geohash":
              geoPoint.data[
                  'geohash'],
          "geopoint":
              geoPoint.data[
                  'geopoint'],
        },

        // ─────────────────────────
        // IDENTITY
        // ─────────────────────────

        "identity": {
          "business_name":
              nameController.text
                  .trim(),

          "legal_entity_name":
              legalNameController
                  .text
                  .trim(),

          "owner_name":
              ownerNameController
                  .text
                  .trim(),

          "fssai":
              fssaiController.text
                  .trim(),

          "imageUrl":
              imageUrl,
        },

        // ─────────────────────────
        // LOCATION
        // ─────────────────────────

        "location": {
          "city":
              cityController.text
                  .trim(),

          "full_address":
              addressController.text
                  .trim(),
        },

        // ─────────────────────────
        // OPERATIONS
        // ─────────────────────────

        "operations": {
          "is_active":
              isActive,

          "is_currently_open":
              isCurrentlyOpen,

          "is_accepting_orders":
              true,
         "busy_mode":
              false,
        },

        // ─────────────────────────
        // RATINGS
        // ─────────────────────────

        "ratings": {
          "average": 0,
          "total_count": 0,
        },

        // ─────────────────────────
        // TAGS
        // ─────────────────────────

        "tags": [
          if (isVeg)
            "pure_veg",
        ],

        // ─────────────────────────
        // TOKENS
        // ─────────────────────────

        "fcm_token": "",

        // ─────────────────────────
        // TIMESTAMPS
        // ─────────────────────────

        "createdAt":
            FieldValue
                .serverTimestamp(),

        "updatedAt":
            FieldValue
                .serverTimestamp(),

       "last_token_update":
    FieldValue
        .serverTimestamp(),
});

debugPrint("STEP 5 FIRESTORE DONE");

debugPrint(
  "VENDOR SUCCESSFULLY CREATED",
);

   if (!mounted) return;

// SUCCESS
      // ─────────────────────────────

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "Vendor onboarded successfully",
          ),
        ),
      );

      // ─────────────────────────────
      // CLEAR FORM
      // ─────────────────────────────

      nameController.clear();

      legalNameController.clear();

      ownerNameController.clear();

      emailController.clear();

      passwordController.clear();

      phoneController.clear();

      gstController.clear();

      fssaiController.clear();

      categoryController.clear();

      addressController.clear();

      cityController.clear();

      latController.clear();

      lngController.clear();

setState(() {
  imageFile = null;
  isVeg = false;
});

} on FirebaseAuthException catch (e) {

  debugPrint(
    "AUTH ERROR CODE: ${e.code}",
  );

  debugPrint(
    "AUTH ERROR MESSAGE: ${e.message}",
  );

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        e.message ?? "Authentication error",
      ),
    ),
  );
} catch (e, stackTrace) {
debugPrint(
  "GENERAL ERROR: $e",
);

debugPrint(
  "STACKTRACE: $stackTrace",
);

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      "Error: $e",
    ),
  ),
);
} finally {
  if (mounted) {
    setState(() {
      isLoading = false;
    });
  }
}
}

  // ─────────────────────────────────────
  // INPUT STYLE
  // ─────────────────────────────────────

  InputDecoration inputStyle(
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor:
          Colors.white.withOpacity(
        0.05,
      ),
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide:
            BorderSide.none,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white
              .withOpacity(0.08),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide:
            const BorderSide(
          color: Color(0xFFFF5A5F),
          width: 1.5,
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),
      body: Row(
  children: [
    // ─────────────────────────────
    // SIDEBAR
    // ─────────────────────────────

    Container(
      width: 270,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1324),
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF5A5F),
                  Color(0xFFFF8A5B),
                ],
              ),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Biteo Business",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 50),

          sideBarItem(
            icon: Icons.dashboard_rounded,
            title: "Dashboard",
            value: "dashboard",
          ),

          sideBarItem(
            icon: Icons.add_business_rounded,
            title: "Onboard Vendor",
            value: "onboard",
          ),

          sideBarItem(
            icon: Icons.store_rounded,
            title: "Active Vendors",
            value: "vendors",
          ),

          sideBarItem(
  icon: Icons.people_rounded,
  title: "Active Users",
  value: "users",
),

          sideBarItem(
            icon: Icons.block_rounded,
            title: "Blocked Vendors",
            value: "blocked_vendors",
          ),

          sideBarItem(
            icon: Icons.people_alt_rounded,
            title: "Blocked Users",
            value: "blocked_users",
          ),

          sideBarItem(
            icon: Icons.support_agent_rounded,
            title: "Support",
            value: "support",
          ),

          sideBarItem(
            icon: Icons.pending_actions_rounded,
            title: "Join Requests",
            value: "join_requests",
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (!mounted) return;

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Logout"),
              ),
            ),
          ),
        ],
      ),
    ),

    // ─────────────────────────────
    // PAGE CONTENT
    // ─────────────────────────────

    Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
       child: buildPage(),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────
// SIDEBAR ITEM
// ─────────────────────────────────────

Widget sideBarItem({
  required IconData icon,
  required String title,
  required String value,
}) {
  final selected = selectedPage == value;

  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 4,
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          selectedPage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: selected
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFF5A5F),
                    Color(0xFFFF8A5B),
                  ],
                )
              : null,
          color:
              selected
                  ? null
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────
// PAGE SWITCHER
// ─────────────────────────────────────

Widget buildPage() {
  switch (selectedPage) {
    case "dashboard":
      return DashboardHomeScreen();

    case "vendors":
  return const ActiveVendorsScreen();

case "users":
  return const ActiveUsersScreen();

    case "blocked_vendors":
      return BlockedVendorsScreen();

    case "blocked_users":
      return BlockedUsersScreen();

    case "support":
      return SupportScreen();

    case "join_requests":
      return JoinRequestsScreen();

    case "onboard":
    default:
      return buildOnboardingPage();
  }
}

// ─────────────────────────────────────
// ONBOARD PAGE
// ─────────────────────────────────────

Widget buildOnboardingPage() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF070B17),
          Color(0xFF111827),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Restaurant Onboarding",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Create and manage restaurant partners for Biteo",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

             Center(
  child: GestureDetector(
    onTap: pickImage,
    child: CircleAvatar(
      radius: 60,
      backgroundColor:
          Colors.white.withOpacity(0.08),
backgroundImage: imageFile != null
    ? kIsWeb
        ? NetworkImage(
            imageFile!.path,
          ) as ImageProvider
        : FileImage(
            File(imageFile!.path),
          )
    : null,
      child: imageFile == null
          ? const Icon(
              Icons.add_a_photo_rounded,
              size: 40,
              color: Colors.white70,
            )
          : null,
    ),
  ),
),

const SizedBox(height: 30),

const Text(
  "Business Details",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
),

const SizedBox(height: 18),

Wrap(
  spacing: 18,
  runSpacing: 18,
  children: [
    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: nameController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Restaurant Name"),
),
    ),

sizedField(
  400,
  TextField(
    textInputAction: TextInputAction.next,
    controller: legalNameController,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration:
        inputStyle("Legal Entity Name"),
  ),
),

    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: ownerNameController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Owner Name"),
),
    ),

    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: categoryController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Category"),
),
    ),
  ],
),

const SizedBox(height: 34),

const Text(
  "Vendor Account",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
),

const SizedBox(height: 18),

Wrap(
  spacing: 18,
  runSpacing: 18,
  children: [
    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  keyboardType:
      TextInputType.emailAddress,
  controller: emailController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration: inputStyle("Email"),
),
    ),

    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: passwordController,
  obscureText: true,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Password"),
),
    ),

    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  keyboardType:
      TextInputType.phone,
  controller: phoneController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Phone Number"),
),
    ),
  ],
),

const SizedBox(height: 34),

const Text(
  "Legal Details",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
),

const SizedBox(height: 18),

Wrap(
  spacing: 18,
  runSpacing: 18,
  children: [
    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: gstController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("GST Number"),
),
    ),

    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: fssaiController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("FSSAI Number"),
),
    ),
  ],
),

const SizedBox(height: 34),

const Text(
  "Location",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
),

const SizedBox(height: 18),

Wrap(
  spacing: 18,
  runSpacing: 18,
  children: [
    sizedField(
      818,
TextField(
  textInputAction: TextInputAction.next,
  controller: addressController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Full Address"),
),
    ),

    sizedField(
      400,
TextField(
  textInputAction: TextInputAction.next,
  controller: cityController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration: inputStyle("City"),
),
    ),

    sizedField(
      190,
TextField(
  textInputAction: TextInputAction.next,
  keyboardType:
      const TextInputType.numberWithOptions(
    decimal: true,
  ),
  controller: latController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Latitude"),
),
    ),

    sizedField(
      190,
TextField(
  textInputAction: TextInputAction.done,
  keyboardType:
      const TextInputType.numberWithOptions(
    decimal: true,
  ),
  controller: lngController,
  style: const TextStyle(
    color: Colors.white,
  ),
  decoration:
      inputStyle("Longitude"),
),
    ),
  ],
),

const SizedBox(height: 30),

Row(
  children: [
    Expanded(
      child: switchCard(
        title: "Pure Veg",
        value: isVeg,
        onChanged: (v) {
          setState(() {
            isVeg = v;
          });
        },
      ),
    ),

    const SizedBox(width: 16),

    Expanded(
      child: switchCard(
        title: "Restaurant Open",
        value: isCurrentlyOpen,
        onChanged: (v) {
          setState(() {
            isCurrentlyOpen = v;
          });
        },
      ),
    ),

    const SizedBox(width: 16),

    Expanded(
      child: switchCard(
        title: "Vendor Active",
        value: isActive,
        onChanged: (v) {
          setState(() {
            isActive = v;
          });
        },
      ),
    ),
  ],
),

const SizedBox(height: 40),

SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton(
    onPressed:
        isLoading ? null : createVendor,
    style: ElevatedButton.styleFrom(
      backgroundColor:
          const Color(0xFFFF5A5F),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
    ),
    child: isLoading
        ? const CircularProgressIndicator(
            color: Colors.white,
          )
        : const Text(
            "Create Vendor",
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
              color: Colors.white,
            ),
          ),
  ),
),
            ],
          ),
        ),
      ),
    ),
  );
}
  Widget sizedField(
    double width,
    Widget child,
  ) {
    return SizedBox(
      width: width,
      child: child,
    );
  }

  // ─────────────────────────────────────
  // SWITCH CARD
  // ─────────────────────────────────────

  Widget switchCard({
    required String title,
    required bool value,
    required Function(bool)
        onChanged,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(
          0.05,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              Colors.white.withOpacity(
            0.08,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            activeColor:
                const Color(
              0xFFFF5A5F,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}