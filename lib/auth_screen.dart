import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'vendor_form_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() =>
      _AuthScreenState();
}

class _AuthScreenState
    extends State<AuthScreen> {
  final codeController =
      TextEditingController();

  bool isLoading = false;

  // ─────────────────────────────────────────
  // TOTP SHARED SECRET
  // ─────────────────────────────────────────
  // Provided at compile time via --dart-define.
  //   flutter run --dart-define=ADMIN_TOTP_SECRET=<value>
  //
  // SECURITY WARNING: this is a client-side TOTP gate only.
  // Any secret compiled into a Flutter client can be extracted.
  // This is a CRITICAL SECURITY ARCHITECTURE ISSUE and must be
  // replaced with server-side authentication. See docs/security.md.
  // ─────────────────────────────────────────
  static const String secret =
      String.fromEnvironment(
    'ADMIN_TOTP_SECRET',
    defaultValue:
        'YOUR_TOTP_SECRET',
  );

  // ─────────────────────────────
  // VERIFY CODE
  // ─────────────────────────────
  void verifyCode() async {
    setState(() {
      isLoading = true;
    });

    final code =
        generateTOTP(secret);

    await Future.delayed(
      const Duration(
        milliseconds: 600,
      ),
    );

    if (codeController.text
            .trim() ==
        code) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  const VendorFormScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.red,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          content: const Text(
            "Invalid Authentication Code",
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ─────────────────────────────
  // TOTP GENERATOR
  // ─────────────────────────────
  String generateTOTP(
    String secret,
  ) {
    final key =
        base32Decode(secret);

    int time =
        DateTime.now()
                .millisecondsSinceEpoch ~/
            1000 ~/
            30;

    final bytes = Uint8List(8);

    for (int i = 7;
        i >= 0;
        i--) {
      bytes[i] = time & 0xff;
      time = time >> 8;
    }

    final hmacSha1 =
        Hmac(sha1, key);

    final hash =
        hmacSha1
            .convert(bytes)
            .bytes;

    final offset =
        hash.last & 0xf;

    final binary =
        ((hash[offset] & 0x7f)
                << 24) |
            ((hash[offset + 1] &
                    0xff)
                << 16) |
            ((hash[offset + 2] &
                    0xff)
                << 8) |
            (hash[offset + 3] &
                0xff);

    final otp =
        binary % 1000000;

    return otp
        .toString()
        .padLeft(6, '0');
  }

  // ─────────────────────────────
  // BASE32 DECODER
  // ─────────────────────────────
  List<int> base32Decode(
    String input,
  ) {
    const base32Chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    input = input.replaceAll(
      '=',
      '',
    );

    List<int> bytes = [];

    int buffer = 0;

    int bitsLeft = 0;

    for (var char
        in input.split('')) {
      int val =
          base32Chars.indexOf(
        char.toUpperCase(),
      );

      if (val < 0) continue;

      buffer <<= 5;

      buffer |= val & 31;

      bitsLeft += 5;

      if (bitsLeft >= 8) {
        bytes.add(
          (buffer >>
                  (bitsLeft - 8)) &
              255,
        );

        bitsLeft -= 8;
      }
    }

    return bytes;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  // ─────────────────────────────
  // UI
  // ─────────────────────────────
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF070B17),
      body: Stack(
        children: [
          // ─────────────────────────
          // BACKGROUND GLOW
          // ─────────────────────────

          Positioned(
            top: -150,
            left: -100,
            child: Container(
              width: 340,
              height: 340,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color: const Color(
                  0xFFFF5A5F,
                ).withOpacity(0.22),
              ),
            ),
          ),

          Positioned(
            bottom: -180,
            right: -120,
            child: Container(
              width: 380,
              height: 380,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color: Colors
                    .deepPurple
                    .withOpacity(0.18),
              ),
            ),
          ),

          // ─────────────────────────
          // MAIN CARD
          // ─────────────────────────

          Center(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                32,
              ),
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  width: 430,
                  padding:
                      const EdgeInsets.all(
                    34,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .white
                        .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      32,
                    ),
                    border: Border.all(
                      color: Colors
                          .white
                          .withOpacity(
                        0.08,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .black
                            .withOpacity(
                          0.3,
                        ),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      // ─────────────────
                      // ICON
                      // ─────────────────

                      Container(
                        width: 90,
                        height: 90,
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(
                                0xFFFF5A5F,
                              ),
                              Color(
                                0xFFFF8A5B,
                              ),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .shield_rounded,
                          color:
                              Colors.white,
                          size: 46,
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      // ─────────────────
                      // TITLE
                      // ─────────────────

                      const Text(
                        "Biteo Secure Access",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 32,
                          fontWeight:
                              FontWeight
                                  .w800,
                          letterSpacing:
                              -1,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        "Protected onboarding panel for restaurant management",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors
                              .white
                              .withOpacity(
                            0.7,
                          ),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(
                        height: 34,
                      ),

                      // ─────────────────
                      // INPUT
                      // ─────────────────

                      TextField(
                        controller:
                            codeController,
                        keyboardType:
                            TextInputType
                                .number,
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .w600,
                          letterSpacing:
                              4,
                        ),
                        textAlign:
                            TextAlign.center,
                        decoration:
                            InputDecoration(
                          filled: true,
                          fillColor:
                              Colors.white
                                  .withOpacity(
                            0.05,
                          ),
                          hintText:
                              "000000",
                          hintStyle:
                              TextStyle(
                            color: Colors
                                .white
                                .withOpacity(
                              0.25,
                            ),
                            letterSpacing:
                                4,
                          ),
                          labelText:
                              "Authenticator Code",
                          labelStyle:
                              TextStyle(
                            color: Colors
                                .white
                                .withOpacity(
                              0.6,
                            ),
                          ),
                          prefixIcon:
                              const Icon(
                            Icons
                                .lock_clock_rounded,
                            color:
                                Color(
                              0xFFFF5A5F,
                            ),
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                            borderSide:
                                BorderSide(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.08,
                              ),
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                            borderSide:
                                const BorderSide(
                              color: Color(
                                0xFFFF5A5F,
                              ),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      // ─────────────────
                      // BUTTON
                      // ─────────────────

                      SizedBox(
                        width:
                            double.infinity,
                        height: 58,
                        child:
                            ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : verifyCode,
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFFFF5A5F,
                            ),
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                      width:
                                          24,
                                      height:
                                          24,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth:
                                            2.5,
                                        color:
                                            Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Verify & Continue",
                                      style:
                                          TextStyle(
                                        fontSize:
                                            16,
                                        fontWeight:
                                            FontWeight.w700,
                                        color:
                                            Colors.white,
                                      ),
                                    ),
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // ─────────────────
                      // FOOTER
                      // ─────────────────

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              14,
                          vertical: 12,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white
                              .withOpacity(
                            0.05,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons
                                  .verified_user_rounded,
                              color:
                                  Color(
                                0xFFFF5A5F,
                              ),
                              size: 20,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                "Two-factor authentication enabled for secure vendor onboarding",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.72,
                                  ),
                                  fontSize:
                                      13,
                                  height:
                                      1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}