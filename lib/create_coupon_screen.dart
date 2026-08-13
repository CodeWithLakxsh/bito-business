// ============================================================
// create_coupon_screen.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  State<CreateCouponScreen> createState() =>
      _CreateCouponScreenState();
}

class _CreateCouponScreenState
    extends State<CreateCouponScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _codeController =
          TextEditingController();

  final TextEditingController
      _descriptionController =
          TextEditingController();

  final TextEditingController
      _valueController =
          TextEditingController();

  final TextEditingController
      _minOrderController =
          TextEditingController();

  final TextEditingController
      _maxDiscountController =
          TextEditingController();

  final TextEditingController
      _usageLimitController =
          TextEditingController();

  String couponType = 'flat';

  bool isActive = true;

  DateTime expiryDate =
      DateTime.now().add(
    const Duration(days: 30),
  );

  bool isLoading = false;

  Future<void> _pickExpiryDate() async {

    final picked =
        await showDatePicker(
      context: context,

      initialDate: expiryDate,

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        expiryDate = picked;
      });
    }
  }

  Future<void> _createCoupon() async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseFirestore.instance
          .collection('coupons')
          .add({

        "code":
            _codeController.text
                .trim()
                .toUpperCase(),

        "description":
            _descriptionController.text
                .trim(),

        "type":
            couponType,

        "value":
            double.parse(
          _valueController.text,
        ),

        "minOrderAmount":
            double.parse(
          _minOrderController.text,
        ),

        "maxDiscount":
            double.parse(
          _maxDiscountController.text,
        ),

        "isActive":
            isActive,

        "usageLimit":
            int.parse(
          _usageLimitController.text,
        ),

        "usedCount": 0,

        "vendorId": "",

        "expiryDate":
            Timestamp.fromDate(
          expiryDate,
        ),

        "createdAt":
            FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Coupon Created"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {

    _codeController.dispose();

    _descriptionController.dispose();

    _valueController.dispose();

    _minOrderController.dispose();

    _maxDiscountController.dispose();

    _usageLimitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF111827),

        title: const Text(
          "Create Coupon",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              _field(
                controller:
                    _codeController,

                label:
                    "Coupon Code",
              ),

              const SizedBox(height: 18),

              _field(
                controller:
                    _descriptionController,

                label:
                    "Description",
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                value: couponType,

                dropdownColor:
                    const Color(
                  0xFF111827,
                ),

                decoration:
                    _inputDecoration(
                  "Coupon Type",
                ),

                items: const [

                  DropdownMenuItem(
                    value: 'flat',

                    child:
                        Text("Flat"),
                  ),

                  DropdownMenuItem(
                    value:
                        'percentage',

                    child: Text(
                      "Percentage",
                    ),
                  ),
                ],

                onChanged: (v) {
                  setState(() {
                    couponType =
                        v!;
                  });
                },
              ),

              const SizedBox(height: 18),

              _field(
                controller:
                    _valueController,

                label:
                    "Discount Value",

                number: true,
              ),

              const SizedBox(height: 18),

              _field(
                controller:
                    _minOrderController,

                label:
                    "Minimum Order",

                number: true,
              ),

              const SizedBox(height: 18),

              _field(
                controller:
                    _maxDiscountController,

                label:
                    "Maximum Discount",

                number: true,
              ),

              const SizedBox(height: 18),

              _field(
                controller:
                    _usageLimitController,

                label:
                    "Usage Limit",

                number: true,
              ),

              const SizedBox(height: 24),

              Row(
                children: [

                  Expanded(
                    child: Text(
                      "Active Coupon",

                      style:
                          const TextStyle(
                        color:
                            Colors.white,

                        fontSize: 16,
                      ),
                    ),
                  ),

                  Switch(
                    value:
                        isActive,

                    onChanged: (v) {
                      setState(() {
                        isActive =
                            v;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap:
                    _pickExpiryDate,

                child: Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets
                          .all(18),

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
                      18,
                    ),
                  ),

                  child: Text(
                    "Expiry: ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}",

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : _createCoupon,

                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Create Coupon",
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController
        controller,

    required String label,

    bool number = false,
  }) {

    return TextFormField(
      controller: controller,

      keyboardType: number
          ? TextInputType.number
          : TextInputType.text,

      style: const TextStyle(
        color: Colors.white,
      ),

      validator: (v) {

        if (v == null ||
            v.trim().isEmpty) {
          return "Required";
        }

        return null;
      },

      decoration:
          _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(
    String label,
  ) {

    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(
        color: Colors.white70,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(
        0.05,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),

        borderSide: BorderSide.none,
      ),
    );
  }
}